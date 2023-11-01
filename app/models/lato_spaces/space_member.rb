module LatoSpaces
  class SpaceMember < ApplicationRecord
    self.table_name = 'lato_space_members'

    # Relations
    ##

    belongs_to :lato_space, class_name: 'LatoSpaces::Space', foreign_key: 'lato_space_id'
    belongs_to :lato_user, class_name: 'Lato::User', foreign_key: 'lato_user_id'
  end
end
