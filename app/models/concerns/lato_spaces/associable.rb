module LatoSpaces::Associable
  extend ActiveSupport::Concern

  included do
    # Relations
    ##

    has_many :lato_spaces_associations, class_name: 'LatoSpaces::Association', as: :item, dependent: :destroy
    has_many :lato_spaces_groups, through: :lato_spaces_associations, class_name: 'LatoSpaces::Group'

    # Scopes
    ##

    scope :for_lato_spaces_group, -> (group) { joins(:lato_spaces_groups).where(lato_spaces_groups: { id: group.id }) }
  end
end
