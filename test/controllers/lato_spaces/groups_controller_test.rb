require "test_helper"

module LatoSpaces
  class GroupsControllerTest < ActionDispatch::IntegrationTest
    setup do
      Rails.cache.clear
      @user = lato_users(:user)
    end

    # index
    ##

    test "index should response with redirect without session" do
      get lato_spaces.groups_url
      assert_response :redirect
    end

    test "index should response with success with session" do
      authenticate_user

      get lato_spaces.groups_url
      assert_response :success
    end

    # create
    ##

    test "create should response with redirect without session" do
      get lato_spaces.groups_create_url
      assert_response :redirect
    end

    test "create should response with success with session" do
      authenticate_user

      get lato_spaces.groups_create_url
      assert_response :success
    end
  end
end
