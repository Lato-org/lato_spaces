module LatoSpaces::AssociableRequired
  extend ActiveSupport::Concern

  attr_writer :lato_spaces_group_id

  included do
    # Validates
    ##

    validates :lato_spaces_group_id, presence: true, on: :create

    # Hooks
    ##

    after_create_commit do
      unless lato_spaces_associations.create(lato_spaces_group_id: lato_spaces_group_id)
        Rails.logger.error "Failed to create LatoSpaces association for #{self.class.name} with ID #{id} and group ID #{lato_spaces_group_id}"
      end
    end

    # External hooks
    ##

    # listen LatoSpaces::Association destroy event to destroy item
    LatoSpaces::Association.after_destroy_commit do |association|
      if association.item
        unless association.item.destroy
          Rails.logger.error "Failed to destroy #{association.item.class.name} with ID #{association.item_id} after LatoSpaces association destruction"
        end
      end
    end
  end
end
