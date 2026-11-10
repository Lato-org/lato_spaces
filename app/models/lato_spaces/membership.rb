module LatoSpaces
  class Membership < ApplicationRecord
    include LatoSpacesMembershipApplication

    attr_accessor :email
    attr_accessor :invitations_disabled # when true, unregistered emails are rejected instead of invited
    attr_accessor :user_infos, :actions # lato index

    # Relations
    ##

    belongs_to :lato_spaces_group, class_name: 'LatoSpaces::Group', foreign_key: 'lato_spaces_group_id'
    belongs_to :lato_user, class_name: 'Lato::User', optional: true
    belongs_to :lato_invitation, class_name: 'Lato::Invitation', optional: true

    # Scopes
    ##

    scope :lato_index_order, ->(column, order) do
      direction = order.to_s.casecmp?('desc') ? 'DESC' : 'ASC'
      return left_joins(:lato_user, :lato_invitation).order(Arel.sql("lato_users.last_name #{direction}, lato_users.first_name #{direction}, lato_users.email #{direction}, lato_invitations.email #{direction}")) if column == :user_infos

      order(column => direction)
    end
  
    scope :lato_index_search, ->(search) do
      left_joins(:lato_user, :lato_invitation).where("lower(lato_users.first_name) LIKE :search OR lower(lato_users.last_name) LIKE :search OR lower(lato_users.email) LIKE :search OR lower(lato_invitations.email) LIKE :search", search: "%#{search.downcase.strip}%")
    end

    # Validations
    ##

    validate on: :create do
      next if lato_user_id.present? || lato_invitation_id.present?

      if email.blank?
        errors.add(:email, :blank)
      elsif invitations_disabled
        errors.add(:email, :invitation_not_permitted)
      end
    end

    validate on: :create do
      group_memberships = LatoSpaces::Membership.where(lato_spaces_group_id: lato_spaces_group_id)
      taken = (lato_user_id.present? && group_memberships.exists?(lato_user_id: lato_user_id)) ||
              (lato_invitation_id.present? && group_memberships.exists?(lato_invitation_id: lato_invitation_id))
      errors.add(:email, :already_member) if taken
    end

    # Hooks
    ##

    # resolve email to an existing user or invitation
    before_validation on: :create do
      self.email = email.to_s.strip.downcase.presence
      next if lato_user_id.present? || lato_invitation_id.present? || email.blank?

      self.lato_user = Lato::User.find_by(email: email)
      self.lato_invitation = Lato::Invitation.find_by(email: email) unless lato_user
    end

    # create (and send) the invitation only once validations passed
    before_create do
      next if lato_user_id.present? || lato_invitation_id.present?

      invitation = Lato::Invitation.create(email: email)
      unless invitation.persisted?
        errors.add(:base, invitation.errors.full_messages.to_sentence.presence || :invitation_error)
        throw(:abort)
      end
      self.lato_invitation = invitation
    end

    # External hooks
    ##

    # listen Lato::Invitation save event to update memberships
    Lato::Invitation.after_save do |invitation|
      next if invitation.lato_user_id.blank?

      LatoSpaces::Membership.where(lato_invitation_id: invitation.id).each do |space_member|
        if LatoSpaces::Membership.exists?(lato_spaces_group_id: space_member.lato_spaces_group_id, lato_user_id: invitation.lato_user_id)
          space_member.destroy!
        else
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

    # show_name: false hides the registered user's full name (only the email is shown)
    def user_infos_label(show_name: true)
      return (show_name ? lato_user.full_name : lato_user.email) if lato_user.present?
      return lato_invitation.email if lato_invitation.present?

      I18n.t('lato_spaces.unknown_member')
    end

    # Operations
    ##

    def set_preferred
      ActiveRecord::Base.transaction do
        LatoSpaces::Membership.where(lato_user_id: lato_user_id).update_all(preferred: false)
        update!(preferred: true)
      end

      true
    end

    def send_invite
      if lato_invitation.blank? || lato_user.present?
        errors.add(:base, :already_joined)
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
