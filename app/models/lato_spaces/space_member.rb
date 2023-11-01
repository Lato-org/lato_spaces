module LatoSpaces
  class SpaceMember < ApplicationRecord
    self.table_name = 'lato_space_members'

    attr_accessor :actions

    # Relations
    ##

    belongs_to :lato_space, class_name: 'LatoSpaces::Space', foreign_key: 'lato_space_id'
    belongs_to :lato_user, class_name: 'Lato::User', foreign_key: 'lato_user_id'

    # Scopes
    ##

    scope :lato_index_order, ->(column, order) do
      return joins(:lato_user).order("lato_users.last_name #{order}, lato_users.first_name #{order}") if column == :lato_user_id
  
      order("#{column} #{order}")
    end
  
    scope :lato_index_search, ->(search) do
      joins(:lato_user).where("lower(lato_users.first_name) LIKE :search OR lower(lato_users.last_name) LIKE :search", search: "%#{search.downcase.strip}%")
    end 

    # Helpers
    ##

    def full_name
      @full_name ||= lato_user.full_name
    end
  end
end
