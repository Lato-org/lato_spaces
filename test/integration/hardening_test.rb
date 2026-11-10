require "test_helper"

class SpacesHardeningTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    Rails.cache.clear
    @user = lato_users(:user)
    @other_user = lato_users(:other_user)
    @group = lato_spaces_groups(:group)
    @user.update!(lato_spaces_admin: false)
  end

  test "welcome message escapes the user name" do
    @user.update!(first_name: "<img src=x onerror=alert(1)>")
    # a second group avoids the dummy single-group auto selection
    LatoSpaces::Group.create!(name: "Second").lato_spaces_memberships.create!(lato_user: @user)
    authenticate_user
    get lato_spaces.root_url
    assert_response :success
    assert_not_includes response.body, "<img src=x onerror=alert(1)>"
    assert_includes response.body, "&lt;img src=x onerror=alert(1)&gt;"
  end

  test "group name is escaped in the show page title" do
    @group.update!(name: "<script>alert(1)</script>")
    authenticate_user
    get lato_spaces.groups_show_url(@group)
    assert_response :success
    assert_not_includes response.body, "<script>alert(1)</script>"
  end

  test "invalid group update renders the form with 422" do
    authenticate_user
    patch lato_spaces.groups_update_action_url(@group), params: { group: { name: "" } }
    assert_response :unprocessable_entity
    assert_equal "Test Group", @group.reload.name
  end

  test "group creation adds the creator as member" do
    authenticate_user
    assert_difference(["LatoSpaces::Group.count", "LatoSpaces::Membership.count"], 1) do
      post lato_spaces.groups_create_action_url, params: { group: { name: "New" } }
    end
    assert LatoSpaces::Group.last.lato_spaces_memberships.exists?(lato_user_id: @user.id)
  end

  test "group creation is rolled back when the membership fails" do
    authenticate_user
    failing_memberships = Object.new
    def failing_memberships.create!(*)
      raise ActiveRecord::RecordInvalid, LatoSpaces::Membership.new.tap { |membership| membership.errors.add(:base, "failure") }
    end
    LatoSpaces::Group.define_singleton_method(:new) do |*args, **kwargs|
      super(*args, **kwargs).tap { |group| group.define_singleton_method(:lato_spaces_memberships) { failing_memberships } }
    end

    assert_no_difference(["LatoSpaces::Group.count", "LatoSpaces::Membership.count"]) do
      post lato_spaces.groups_create_action_url, params: { group: { name: "New" } }
    end
    assert_response :unprocessable_entity
  ensure
    LatoSpaces::Group.singleton_class.remove_method(:new)
  end

  test "non-admin can not invite unregistered emails when signup is disabled" do
    with_signup_disabled do
      authenticate_user
      assert_no_difference(["Lato::Invitation.count", "LatoSpaces::Membership.count"]) do
        post lato_spaces.memberships_create_action_url(@group), params: { membership: { email: "outsider@mail.com" } }
      end
      assert_response :unprocessable_entity

      assert_difference("LatoSpaces::Membership.count", 1) do
        post lato_spaces.memberships_create_action_url(@group), params: { membership: { email: @other_user.email } }
      end
      assert_redirected_to lato_spaces.groups_show_url(@group)
    end
  end

  test "admin can invite unregistered emails when signup is disabled" do
    @user.update!(lato_spaces_admin: true)
    with_signup_disabled do
      authenticate_user
      assert_difference("Lato::Invitation.count", 1) do
        post lato_spaces.memberships_create_action_url(@group), params: { membership: { email: "outsider@mail.com" } }
      end
    end
  end

  test "membership creation is throttled" do
    original_cache = Rails.cache
    Rails.cache = ActiveSupport::Cache::MemoryStore.new
    authenticate_user
    statuses = 20.times.map do |index|
      post lato_spaces.memberships_create_action_url(@group), params: { membership: { email: "user#{index}@mail.com" } }
      response.status
    end
    assert_equal 429, statuses.last
  ensure
    Rails.cache = original_cache
  end

  test "non-admin can not remove the last registered member" do
    authenticate_user
    assert_no_difference("LatoSpaces::Membership.count") do
      delete lato_spaces.memberships_destroy_action_url(lato_spaces_memberships(:membership)), as: :json
    end
    assert_response :unprocessable_entity

    @group.lato_spaces_memberships.create!(lato_user: @other_user)
    delete lato_spaces.memberships_destroy_action_url(lato_spaces_memberships(:membership)), as: :json
    assert_response :no_content
  end

  test "non-admin sees member emails instead of full names" do
    @group.lato_spaces_memberships.create!(lato_user: @other_user)
    authenticate_user
    get lato_spaces.groups_show_url(@group)
    assert_includes response.body, @other_user.email
    assert_not_includes response.body, "Mario Rossi"
  end

  test "non-admin breadcrumbs do not link the admin groups index" do
    authenticate_user
    get lato_spaces.groups_show_url(@group)
    assert_select "a[href=?]", lato_spaces.groups_path, count: 0
  end

  test "admin can select a group from the show page" do
    @user.update!(lato_spaces_admin: true)
    foreign_group = LatoSpaces::Group.create!(name: "Foreign")
    authenticate_user
    get lato_spaces.groups_show_url(foreign_group)
    assert_select "form[action=?]", lato_spaces.setgroup_path(foreign_group)
  end

  test "group cards expose accessible names and selected state" do
    authenticate_user
    post lato_spaces.setgroup_url(@group), as: :json
    get lato_spaces.root_url
    assert_select "[aria-current=true]", 1
    assert_select "button[aria-label=?]", I18n.t("lato_spaces.aria.select_group", name: @group.name)
    assert_select "button[aria-pressed]"
  end

  test "authenticate_group answers JSON requests with 403" do
    authenticate_user
    get "/documentation", as: :json
    assert_response :forbidden
  end

  test "Groupable helpers are not routable actions" do
    actions = LatoSpaces::ApplicationController.action_methods
    %w[authenticate_group session_group_create session_group_destroy].each do |name|
      assert_not_includes actions, name
    end
  end

  test "auto selection after login prefers the preferred group" do
    preferred_group = LatoSpaces::Group.create!(name: "Zeta")
    preferred_group.lato_spaces_memberships.create!(lato_user: @user).set_preferred

    with_spaces_config(setgroup_auto_after_login: true) do
      authenticate_user
      get lato_spaces.root_url
      assert_redirected_to "/documentation"
      assert_equal preferred_group.id, controller.instance_variable_get(:@session).get(:spaces_group_id)
    end
  end

  private

  def with_signup_disabled
    original = Lato.config.auth_disable_signup
    Lato.config.auth_disable_signup = true
    yield
  ensure
    Lato.config.auth_disable_signup = original
  end

  def with_spaces_config(values)
    originals = values.keys.index_with { |key| LatoSpaces.config.public_send(key) }
    values.each { |key, value| LatoSpaces.config.public_send("#{key}=", value) }
    yield
  ensure
    originals.each { |key, value| LatoSpaces.config.public_send("#{key}=", value) }
  end
end
