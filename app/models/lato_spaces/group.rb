module LatoSpaces
  class Group < ApplicationRecord
    attr_accessor :actions

    # Relations
    ##

    has_many :lato_space_memberships, class_name: 'LatoSpaces::Membership', dependent: :destroy

    # Validations
    ##

    validates :name, presence: true
  end
end
