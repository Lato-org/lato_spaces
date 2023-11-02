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

  end
end