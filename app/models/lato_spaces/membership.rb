module LatoSpaces
  class Membership < ApplicationRecord
    attr_accessor :email
    attr_accessor :user_infos, :actions # lato index

    # Relations
    ##

    belongs_to :lato_spaces_group, class_name: 'LatoSpaces::Group', foreign_key: 'lato_spaces_group_id'
    belongs_to :lato_user, class_name: 'Lato::User', optional: true
    belongs_to :lato_invitation, class_name: 'Lato::Invitation', optional: true

    # Scopes
    ##

    scope :lato_index_order, ->(column, order) do
      return left_joins(:lato_user, :lato_invitation).order("lato_users.last_name #{order}, lato_users.first_name #{order}, lato_users.email #{order}, lato_invitations.email #{order}") if column == :user_infos

      order("#{column} #{order}")
    end
  
    scope :lato_index_search, ->(search) do
      left_joins(:lato_user, :lato_invitation).where("lower(lato_users.first_name) LIKE :search OR lower(lato_users.last_name) LIKE :search OR lower(lato_users.email) LIKE :search OR lower(lato_invitations.email) LIKE :search", search: "%#{search.downcase.strip}%")
    end

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
          invitation ||= Lato::Invitation.create(email: email)
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

    # Helpers
    ##

    def user_infos_label
      return lato_user.full_name if lato_user.present?
      return lato_invitation.email if lato_invitation.present?
      'Unknown'
    end

    # Operations
    ##

    def send_invite
      if lato_invitation.blank? || lato_user.present?
        errors.add(:base, 'This user is already a member of this space.')
        return false
      end

      result = lato_invitation.send_invite
      unless result
        errors.add(:base, lato_invitation.errors.full_messages.to_sentence)
        return false
      end

      true
    end
  end
end
