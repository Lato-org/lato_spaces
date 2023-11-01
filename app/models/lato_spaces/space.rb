module LatoSpaces
  class Space < ApplicationRecord
    self.table_name = 'lato_spaces'

    attr_accessor :actions

    # Relations
    ##

    has_many :lato_space_members, class_name: 'LatoSpaces::SpaceMember', foreign_key: 'lato_space_id', dependent: :destroy
    belongs_to :lato_user_creator, class_name: 'Lato::User', foreign_key: 'lato_user_creator_id', optional: true

    # Validations
    ##

    validates :name, presence: true

    # Hooks
    ##

    after_save do
      lato_space_members.create!(lato_user_id: lato_user_creator_id)
    end
  end
end
