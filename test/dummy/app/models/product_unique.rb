class ProductUnique < ApplicationRecord
  include LatoSpaces::Associable
  include LatoSpaces::AssociableUnique
end
