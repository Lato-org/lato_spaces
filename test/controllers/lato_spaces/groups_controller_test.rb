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

    # create_action
    ##

    test "create_action should response with redirect without session" do
      post lato_spaces.groups_create_action_url, params: {
        group: {
          name: 'test'
        }
      }
      assert_response :redirect
    end

    test "create_action should create the group" do
      authenticate_user

      post lato_spaces.groups_create_action_url, params: {
        group: {
          name: 'test'
        }
      }
      assert_redirected_to lato_spaces.groups_show_url(LatoSpaces::Group.last)

      group = LatoSpaces::Group.last
      assert_equal group.name, 'test'
    end

    # show
    ##

    test "show should response with redirect without session" do
      group = lato_spaces_groups(:group)

      get lato_spaces.groups_show_url(group)
      assert_response :redirect
    end

    test "show should response with success with session" do
      authenticate_user
      group = lato_spaces_groups(:group)

      get lato_spaces.groups_show_url(group)
      assert_response :success
    end

    # update
    ##

    test "update should response with redirect without session" do
      group = lato_spaces_groups(:group)

      get lato_spaces.groups_update_url(group)
      assert_response :redirect
    end

    test "update should response with success with session" do
      authenticate_user
      group = lato_spaces_groups(:group)

      get lato_spaces.groups_update_url(group)
      assert_response :success
    end

    # update_action
    ##

    test "update_action should response with redirect without session" do
      group = lato_spaces_groups(:group)

      patch lato_spaces.groups_update_action_url(group, params: {
        group: {
          name: 'test'
        }
      })
      assert_response :redirect
    end

    test "update_action should update the group" do
      authenticate_user
      group = lato_spaces_groups(:group)

      patch lato_spaces.groups_update_action_url(group, params: {
        group: {
          name: 'test'
        }
      })
      assert_redirected_to lato_spaces.groups_show_url(group)

      group.reload
      assert_equal group.name, 'test'
    end

    # destroy_action
    ##

    test "destroy_action should response with redirect without session" do
      group = lato_spaces_groups(:group)

      delete lato_spaces.groups_destroy_action_url(group)
      assert_response :redirect
    end

    test "destroy_action should destroy the group" do
      authenticate_user
      group = lato_spaces_groups(:group)

      delete lato_spaces.groups_destroy_action_url(group)
      assert_redirected_to lato_spaces.groups_url

      assert_not LatoSpaces::Group.exists?(group.id)
    end
  end
end
