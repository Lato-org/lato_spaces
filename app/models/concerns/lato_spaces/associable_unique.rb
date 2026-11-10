module LatoSpaces::AssociableUnique
  extend ActiveSupport::Concern

  # Marker concern: LatoSpaces::Association rejects a second association
  # for items including this module.
end
