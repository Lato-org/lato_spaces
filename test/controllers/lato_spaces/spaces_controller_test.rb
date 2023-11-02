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

    # create
    ##

    test "create should response with redirect without session" do
      get lato_spaces.spaces_create_url
      assert_response :redirect
    end

    test "create should response with success with session" do
      authenticate_user

      get lato_spaces.spaces_create_url
      assert_response :success
    end

    # create_action
    ##

    test "create_action should response with redirect without session" do
      post lato_spaces.spaces_create_action_url
      assert_response :redirect
    end

    test "create_action should create a new space" do
      authenticate_user

      post lato_spaces.spaces_create_action_url, params: {
        space: {
          name: 'test'
        }
      }
      assert_redirected_to lato_spaces.spaces_path

      # check if space is created
      last_created_space = LatoSpaces::Space.last
      assert_equal last_created_space.name, 'test'
      assert_equal last_created_space.lato_user_creator_id, @user.id
    end

    # update
    ##

    test "update should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      get lato_spaces.spaces_update_url(space)
      assert_response :redirect
    end

    test "update should response with success with session" do
      authenticate_user
      space = lato_spaces_spaces(:space)

      get lato_spaces.spaces_update_url(space)
      assert_response :success
    end

    # update_action
    ##

    test "update_action should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      patch lato_spaces.spaces_update_action_url(space)
      assert_response :redirect
    end

    test "update_action should update a space" do
      authenticate_user
      space = lato_spaces_spaces(:space)

      patch lato_spaces.spaces_update_action_url(space), params: {
        space: {
          name: 'test'
        }
      }
      assert_redirected_to lato_spaces.spaces_path

      # check if space is updated
      space.reload
      assert_equal space.name, 'test'
    end

    # destroy_action
    ##

    test "destroy_action should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      delete lato_spaces.spaces_destroy_action_url(space)
      assert_response :redirect
    end

    test "destroy_action should destroy a space" do
      authenticate_user
      space = lato_spaces_spaces(:space)

      delete lato_spaces.spaces_destroy_action_url(space)
      assert_redirected_to lato_spaces.spaces_path

      # check if space is destroyed
      assert_nil LatoSpaces::Space.find_by(id: space.id)
    end

    # members_create
    ##

    test "members_create should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      get lato_spaces.spaces_members_create_url(space)
      assert_response :redirect
    end

    test "members_create should response with success with session" do
      authenticate_user

      space = lato_spaces_spaces(:space)
      get lato_spaces.spaces_members_create_url(space)
      assert_response :success
    end

    # members_create_action
    ##

    test "members_create_action should response with redirect without session" do
      space = lato_spaces_spaces(:space)

      post lato_spaces.spaces_members_create_action_url(space, params: {
        space_member: {
          email: 'test@mail.com'
        }
      })
      assert_response :redirect
    end

    test "members_create_action should create a new space member" do
      authenticate_user

      space = lato_spaces_spaces(:space)
      post lato_spaces.spaces_members_create_action_url(space, params: {
        space_member: {
          email: 'test@mail.com'
        }
      })
      assert_redirected_to lato_spaces.spaces_members_url(space)
    end

    # members_send_invite_action
    ##

    test "members_send_invite_action should response with redirect without session" do
      space_member = lato_spaces_space_members(:space_member_invitation)

      post lato_spaces.spaces_members_send_invite_action_url(space_member)
      assert_response :redirect
    end

    # test "members_send_invite_action should send an invite to a space member" do
    #   authenticate_user

    #   space_member = lato_spaces_space_members(:space_member_invitation)
    #   post lato_spaces.spaces_members_send_invite_action_url(space_member)
    #   assert_redirected_to lato_spaces.spaces_members_url(space_member.lato_space)
    # end

  end
end