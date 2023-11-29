module LatoSpaces
  class Group < ApplicationRecord
    attr_accessor :actions

    # Relations
    ##

    has_many :lato_spaces_memberships, class_name: 'LatoSpaces::Membership', foreign_key: 'lato_spaces_group_id', dependent: :destroy

    # Validations
    ##

    validates :name, presence: true

    # External hooks
    ##

    # listen Lato::User create event to create default group
    Lato::User.after_create do |user|
      if LatoSpaces.config.create_default_group
        group = LatoSpaces::Group.create!(name: LatoSpaces.config.create_default_group_name)
        group.lato_spaces_memberships.create!(lato_user_id: user.id)
      end
    end
  end
end
