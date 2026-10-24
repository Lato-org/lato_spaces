require "test_helper"

class SpacesSecurityTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    Rails.cache.clear
    @user = lato_users(:user)
    @group = lato_spaces_groups(:group)
    @foreign_group = LatoSpaces::Group.create!(name: "Foreign group")
    @foreign_membership = @foreign_group.lato_spaces_memberships.create!(lato_invitation: lato_invitations(:invitation))
    @user.update!(lato_spaces_admin: false)
  end

  test "users cannot select another group's data scope" do
    authenticate_user
    post lato_spaces.setgroup_url(@foreign_group), as: :json
    assert_response :unprocessable_entity
    get "/documentation"
    assert_redirected_to lato_spaces.root_path
  end

  test "revoking membership clears selected group before protected requests" do
    authenticate_user
    post lato_spaces.setgroup_url(@group), as: :json
    assert_response :success
    get "/documentation"
    assert_response :success

    lato_spaces_memberships(:membership).destroy!
    get "/documentation"
    assert_redirected_to lato_spaces.root_path
    assert_match(/httponly/i, response.headers["Set-Cookie"].to_s)
  end

  test "selection and deselection preserve HTTPS cookie protections" do
    https!
    authenticate_user
    post lato_spaces.setgroup_url(@group), as: :json
    assert_response :success
    assert_match(/secure/i, response.headers["Set-Cookie"].to_s)
    assert_match(/httponly/i, response.headers["Set-Cookie"].to_s)

    lato_spaces_memberships(:membership).destroy!
    get "/documentation"
    assert_redirected_to lato_spaces.root_path
    assert_match(/secure/i, response.headers["Set-Cookie"].to_s)
    assert_match(/httponly/i, response.headers["Set-Cookie"].to_s)
  end

  test "non-admin cannot destroy membership in another group" do
    authenticate_user
    assert_no_difference("LatoSpaces::Membership.count") do
      delete lato_spaces.memberships_destroy_action_url(@foreign_membership), as: :json
      assert_response :not_found
    end
  end

  test "non-admin cannot resend invitation in another group" do
    authenticate_user
    assert_no_enqueued_jobs do
      post lato_spaces.memberships_send_invite_action_url(@foreign_membership), as: :json
      assert_response :not_found
    end
  end

  test "non-admin can manage membership in their own group" do
    authenticate_user
    delete lato_spaces.memberships_destroy_action_url(lato_spaces_memberships(:membership_invitation)), as: :json
    assert_response :no_content
  end

  test "global admin can select and manage foreign groups" do
    @user.update!(lato_spaces_admin: true)
    authenticate_user
    post lato_spaces.setgroup_url(@foreign_group), as: :json
    assert_response :success
    get "/documentation"
    assert_response :success
    delete lato_spaces.memberships_destroy_action_url(@foreign_membership), as: :json
    assert_response :no_content
  end
end
