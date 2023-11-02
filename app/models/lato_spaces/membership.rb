module LatoSpaces
  class Membership < ApplicationRecord
    attr_accessor :email

    # Relations
    ##

    belongs_to :lato_space_group, class_name: 'LatoSpaces::Group', foreign_key: 'lato_spaces_group_id'
    belongs_to :lato_user, class_name: 'Lato::User', optional: true
    belongs_to :lato_invitation, class_name: 'Lato::Invitation', optional: true

    # Hooks
    ##

    # find user or create invitation when create membership
    before_create do
      if new_record? && email.present? && lato_user_id.blank? && lato_invitation_id.blank?
        user = Lato::User.find_by_email(email)
        if user
          self.lato_user_id = user.id
        else
          invitation = Lato::Invitation.find_by_email(email)
          invitation ||= Lato::Invitation.create(email: email, inviter_lato_user_id: lato_user_creator_id)
          unless invitation
            errors.add(:email, 'There was an error with the invitation.')
            throw(:abort)
          end
          self.lato_invitation_id = invitation.id
        end
      end
    end

    # External hooks
    ##

    # listen Lato::Invitation save event to update memberships
    Lato::Invitation.after_save do |invitation|
      if invitation.lato_user_id.present?
        LatoSpaces::Membership.where(lato_invitation_id: invitation.id).each do |space_member|
          space_member.update!(lato_user_id: invitation.lato_user_id, lato_invitation_id: nil)
        end
      end
    end

    # listen Lato::Invitation destroy event to destroy memberships
    Lato::Invitation.after_destroy do |invitation|
      LatoSpaces::Membership.where(lato_invitation_id: invitation.id).destroy_all
    end

    # listen Lato::User destroy event to destroy memberships
    Lato::User.after_destroy do |user|
      LatoSpaces::Membership.where(lato_user_id: user.id).destroy_all
    end
  end
end
