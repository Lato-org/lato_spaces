module LatoSpaces
  class SpaceMember < ApplicationRecord
    self.table_name = 'lato_space_members'

    attr_accessor :email, :actions

    # Relations
    ##

    belongs_to :lato_space, class_name: 'LatoSpaces::Space', foreign_key: 'lato_space_id'
    belongs_to :lato_user, class_name: 'Lato::User', foreign_key: 'lato_user_id', optional: true
    belongs_to :lato_invitation, class_name: 'Lato::Invitation', foreign_key: 'lato_invitation_id', optional: true
    
    belongs_to :lato_user_creator, class_name: 'Lato::User', foreign_key: 'lato_user_creator_id', optional: true

    # Scopes
    ##

    scope :lato_index_order, ->(column, order) do
      return left_joins(:lato_user, :lato_invitation).order("lato_users.last_name #{order}, lato_users.first_name #{order}, lato_users.email #{order}, lato_invitations.email #{order}") if column == :lato_user_id

      order("#{column} #{order}")
    end
  
    scope :lato_index_search, ->(search) do
      left_joins(:lato_user, :lato_invitation).where("lower(lato_users.first_name) LIKE :search OR lower(lato_users.last_name) LIKE :search OR lower(lato_users.email) LIKE :search OR lower(lato_invitations.email) LIKE :search", search: "%#{search.downcase.strip}%")
    end

    # Hooks
    ##

    # find user or create invitation when create space member
    before_create do
      if new_record? && email.present? && lato_user_id.blank? && lato_invitation_id.blank?
        user = Lato::User.find_by_email(email)
        if user
          self.lato_user_id = user.id
        else
          invitation = Lato::Invitation.find_by_email(email)
          invitation ||= Lato::Invitation.create(email: email, inviter_lato_user_id: lato_user_creator_id)
          unless invitation
            errors.add(:email, 'L\'invito non è stato creato correttamente.')
            throw(:abort)
          end
          self.lato_invitation_id = invitation.id
        end
      end
    end

    # destroy invitation when destroy space member
    after_destroy do
      if lato_invitation
        lato_invitation.destroy
      end
    end

    # External hooks
    ##

    # listen Lato::Invitation save event to update space members
    Lato::Invitation.after_save do |invitation|
      if invitation.lato_user_id.present?
        LatoSpaces::SpaceMember.where(lato_invitation_id: invitation.id).each do |space_member|
          space_member.update!(lato_user_id: invitation.lato_user_id, lato_invitation_id: nil)
        end
      end
    end

    # listen Lato::Invitation destroy event to destroy space members
    Lato::Invitation.after_destroy do |invitation|
      LatoSpaces::SpaceMember.where(lato_invitation_id: invitation.id).destroy_all
    end

    # listen Lato::User destroy event to destroy space members and update creator
    Lato::User.after_destroy do |user|
      LatoSpaces::SpaceMember.where(lato_user_id: user.id).destroy_all
      LatoSpaces::SpaceMember.where(lato_user_creator_id: user.id).update_all(lato_user_creator_id: nil)
    end

    # Helpers
    ##

    def full_name
      @full_name ||= lato_user&.full_name || lato_invitation&.email
    end

    def email
      @email ||= lato_user&.email || lato_invitation&.email
    end
  end
end
