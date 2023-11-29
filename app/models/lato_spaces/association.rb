module LatoSpaces
  class Association < ApplicationRecord
    # Relations
    ##

    belongs_to :lato_spaces_group, class_name: 'LatoSpaces::Group', foreign_key: 'lato_spaces_group_id'
    belongs_to :item, polymorphic: true

    # Validations
    ##

    validates :lato_spaces_group_id, uniqueness: { scope: [:item_id, :item_type] }
  end
end
