module LatoSpaces::AssociableRequired
  extend ActiveSupport::Concern

  attr_writer :lato_spaces_group_id

  included do
    # Validates
    ##

    validates :lato_spaces_group_id, presence: true, on: :create

    # Hooks
    ##

    after_create do
      lato_spaces_associations.create!(lato_spaces_group_id: lato_spaces_group_id)
    end

    # External hooks
    ##

    # listen LatoSpaces::Association destroy event to destroy item
    LatoSpaces::Association.after_destroy do |association|
      association.item&.destroy!
    end
  end
end
