module LatoSpaces::AssociableRequired
  extend ActiveSupport::Concern

  # NOTE: LatoSpaces::Association destroys items including this module when
  # their association is destroyed (e.g. on group destruction).

  attr_writer :lato_spaces_group_id

  included do
    # Validates
    ##

    validates :lato_spaces_group_id, presence: true, on: :create
    validate on: :create do
      if lato_spaces_group_id.present? && !LatoSpaces::Group.exists?(id: lato_spaces_group_id)
        errors.add(:lato_spaces_group_id, :invalid)
      end
    end

    # Hooks
    ##

    # Runs inside the create transaction: a failure rolls back the item.
    after_create do
      lato_spaces_associations.create!(lato_spaces_group_id: lato_spaces_group_id)
    end
  end
end
