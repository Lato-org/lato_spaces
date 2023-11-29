module LatoSpaces::AssociableUnique
  extend ActiveSupport::Concern

  included do
    # External hooks
    ##

    # listen LatoSpaces::Association create event to avoid duplicate associations
    LatoSpaces::Association.before_create do |association|
      if association.item_type == self.class.name && association.item_id == id && lato_spaces_associations.count.positive?
        throw(:abort)
      end
    end
  end
end
    