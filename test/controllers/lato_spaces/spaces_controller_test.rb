require "test_helper"

module LatoSpaces
  class SpacesControllerTest < ActionDispatch::IntegrationTest
    setup do
      Rails.cache.clear
      @user = lato_users(:user)
    end

    # index
    ##

    test "index should response with redirect without session" do
      get lato_spaces.spaces_url
      assert_response :redirect
    end

    test "index should response with success with session" do
      authenticate_user

      get lato_spaces.spaces_url
      assert_response :success
    end

    # new
    ##

    test "new should response with redirect without session" do
      get lato_spaces.new_space_url
      assert_response :redirect
    end

    test "new should response with success with session" do
      authenticate_user

      get lato_spaces.new_space_url
      assert_response :success
    end

    # create
    ##

    test "create should response with redirect without session" do
      post lato_spaces.spaces_url, params: { space: { name: 'test' } }
      assert_response :redirect
    end

    test "create should response with success with session" do
      authenticate_user

      post lato_spaces.spaces_url, params: { space: { name: 'test' } }
      assert_response :redirect

      space = LatoSpaces::Space.last
      assert_equal space.name, 'test'
    end

    # edit
    ##

    test "edit should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      get lato_spaces.edit_space_url(space)
      assert_response :redirect
    end

    test "edit should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      get lato_spaces.edit_space_url(space)
      assert_response :success
    end

    # update
    ##

    test "update should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      patch lato_spaces.space_url(space), params: { space: { name: 'test' } }
      assert_response :redirect
    end

    test "update should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      patch lato_spaces.space_url(space), params: { space: { name: 'test' } }
      assert_response :redirect

      space.reload
      assert_equal space.name, 'test'
    end

    # destroy
    ##

    test "destroy should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      delete lato_spaces.space_url(space)
      assert_response :redirect
    end

    test "destroy should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      delete lato_spaces.space_url(space)
      assert_response :redirect

      assert_not LatoSpaces::Space.exists?(space.id)
    end

    # members
    ##

    test "members should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      get lato_spaces.members_space_url(space)
      assert_response :redirect
    end

    test "members should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      get lato_spaces.members_space_url(space)
      assert_response :success
    end

    # new_member
    ##

    test "new_member should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      get lato_spaces.new_member_space_url(space)
      assert_response :redirect
    end

    test "new_member should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      get lato_spaces.new_member_space_url(space)
      assert_response :success
    end

    # create_member
    ##

    test "create_member should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      post lato_spaces.create_member_space_url(space), params: { space_member: { email: 'test@mail.com' } }
      assert_response :redirect
    end

    test "create_member should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)

      post lato_spaces.create_member_space_url(space), params: { space_member: { email: 'test@mail.com' } }
      assert_response :redirect
    end
  end
end