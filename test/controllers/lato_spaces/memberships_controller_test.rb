require "test_helper"

module LatoSpaces
  class MembershipsControllerTest < ActionDispatch::IntegrationTest
    setup do
      Rails.cache.clear
      @user = lato_users(:user)
    end

    # create
    ##

    test "create should response with redirect without session" do
      group = lato_spaces_groups(:group)

      get lato_spaces.memberships_create_url(group)
      assert_response :redirect
    end

    test "create should response with success with session" do
      authenticate_user
      group = lato_spaces_groups(:group)

      get lato_spaces.memberships_create_url(group)
      assert_response :success
    end

    # create_action
    ##

    test "create_action should response with redirect without session" do
      group = lato_spaces_groups(:group)

      post lato_spaces.memberships_create_action_url(group), params: {
        membership: {
          email: 'test@mail.com'
        }
      }
      assert_response :redirect
    end

    test "create_action should create the membership" do
      authenticate_user
      group = lato_spaces_groups(:group)

      post lato_spaces.memberships_create_action_url(group), params: {
        membership: {
          email: 'test@mail.com'
        }
      }
      assert_redirected_to lato_spaces.groups_show_url(group)

      membership = LatoSpaces::Membership.last
      assert_not_nil membership
    end

    # destroy_action
    ##

    test "destroy_action should response with redirect without session" do
      membership = lato_spaces_memberships(:membership)

      delete lato_spaces.memberships_destroy_action_url(membership)
      assert_response :redirect
    end

    test "destroy_action should destroy the membership" do
      authenticate_user
      membership = lato_spaces_memberships(:membership)

      delete lato_spaces.memberships_destroy_action_url(membership)
      assert_redirected_to lato_spaces.groups_show_url(membership.lato_spaces_group)

      assert_nil LatoSpaces::Membership.find_by_id(membership.id)
    end

    # send_invite_action
    ##

    test "send_invite_action should response with redirect without session" do
      membership = lato_spaces_memberships(:membership_invitation)

      post lato_spaces.memberships_send_invite_action_url(membership)
      assert_response :redirect
    end

    test "send_invite_action should send the invite" do
      authenticate_user
      membership = lato_spaces_memberships(:membership_invitation)

      post lato_spaces.memberships_send_invite_action_url(membership)
      assert_redirected_to lato_spaces.groups_show_url(membership.lato_spaces_group)
    end
  end
end
