module LatoSpaces
  class Group < ApplicationRecord
    attr_accessor :actions

    # Relations
    ##

    has_many :lato_spaces_memberships, class_name: 'LatoSpaces::Membership', foreign_key: 'lato_spaces_group_id', dependent: :destroy
    has_many :lato_spaces_associations, class_name: 'LatoSpaces::Association', foreign_key: 'lato_spaces_group_id', dependent: :destroy

    # Validations
    ##

    validates :name, presence: true
  end
end
