module LatoSpaces
  class Association < ApplicationRecord
    # Relations
    ##

    belongs_to :lato_spaces_group, class_name: 'LatoSpaces::Group', foreign_key: 'lato_spaces_group_id'
    belongs_to :item, polymorphic: true

    # Validations
    ##

    validates :lato_spaces_group_id, uniqueness: { scope: [:item_id, :item_type] }

    # Items using LatoSpaces::AssociableUnique can belong to a single group.
    validate on: :create do
      next unless item.is_a?(LatoSpaces::AssociableUnique)
      next unless LatoSpaces::Association.where(item_type: item_type, item_id: item_id).exists?

      errors.add(:item, :already_associated)
    end

    # Hooks
    ##

    # Items using LatoSpaces::AssociableRequired can not live without a group:
    # destroying their association destroys them. The check is done per item,
    # so models using only LatoSpaces::Associable are never affected.
    after_destroy_commit do
      next unless item.is_a?(LatoSpaces::AssociableRequired)

      unless item.destroy
        Rails.logger.error "Failed to destroy #{item_type} with ID #{item_id} after LatoSpaces association destruction"
      end
    end
  end
end
