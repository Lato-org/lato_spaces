require "test_helper"

module LatoSpaces
  class MembershipTest < ActiveSupport::TestCase
    setup do
      @group = LatoSpaces::Group.create!(name: "Group")
      @user = lato_users(:other_user)
    end

    test "email is normalized before resolving the user" do
      membership = @group.lato_spaces_memberships.create(email: "  MARIO.ROSSI@MAIL.COM ")
      assert membership.persisted?
      assert_equal @user.id, membership.lato_user_id
      assert_nil membership.lato_invitation_id
    end

    test "unknown email creates an invitation" do
      membership = @group.lato_spaces_memberships.create(email: "New.User@Mail.com")
      assert membership.persisted?
      assert_equal "new.user@mail.com", membership.lato_invitation.email
    end

    test "blank email is rejected" do
      membership = @group.lato_spaces_memberships.create(email: " ")
      assert_not membership.persisted?
      assert membership.errors[:email].any?
    end

    test "same user can not be added twice to a group" do
      @group.lato_spaces_memberships.create!(email: @user.email)
      membership = @group.lato_spaces_memberships.create(email: @user.email.upcase)
      assert_not membership.persisted?
      assert membership.errors[:email].any?
    end

    test "same invitation can not be added twice to a group" do
      @group.lato_spaces_memberships.create!(email: "new.user@mail.com")
      membership = @group.lato_spaces_memberships.create(email: "new.user@mail.com")
      assert_not membership.persisted?
    end

    test "unique index blocks duplicates skipping validations" do
      @group.lato_spaces_memberships.create!(lato_user: @user)
      assert_raises(ActiveRecord::RecordNotUnique) do
        LatoSpaces::Membership.new(lato_spaces_group: @group, lato_user: @user).save!(validate: false)
      end
    end

    test "invitations_disabled rejects unregistered emails but accepts registered users" do
      rejected = @group.lato_spaces_memberships.create(email: "new.user@mail.com", invitations_disabled: true)
      assert_not rejected.persisted?
      assert rejected.errors[:email].any?
      assert_nil Lato::Invitation.find_by(email: "new.user@mail.com")

      accepted = @group.lato_spaces_memberships.create(email: @user.email, invitations_disabled: true)
      assert accepted.persisted?
    end

    test "accepted invitation of an existing member removes the duplicate membership" do
      @group.lato_spaces_memberships.create!(lato_user: @user)
      invitation = Lato::Invitation.create!(email: "invited.later@mail.com")
      @group.lato_spaces_memberships.create!(lato_invitation: invitation)

      invitation.update_column(:email, @user.email)
      invitation.update!(lato_user_id: @user.id)

      assert_equal 1, @group.lato_spaces_memberships.where(lato_user_id: @user.id).count
      assert_not @group.lato_spaces_memberships.exists?(lato_invitation_id: invitation.id)
    end

    test "user_infos_label can hide the full name" do
      membership = @group.lato_spaces_memberships.create!(lato_user: @user)
      assert_equal @user.full_name, membership.user_infos_label
      assert_equal @user.email, membership.user_infos_label(show_name: false)
    end
  end
end
