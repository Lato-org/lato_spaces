require "test_helper"

class ProductRequiredTest < ActiveSupport::TestCase
  test "concern methods" do
    # Test creation of a LatoSpaces::AssociableRequired item without lato_spaces_group_id.
    product = ProductRequired.create(lato_spaces_group_id: nil)
    assert_not product.valid?
    assert product.errors[:lato_spaces_group_id].any?

    # Test creation of a LatoSpaces::AssociableRequired item with lato_spaces_group_id.
    lato_spaces_group = LatoSpaces::Group.create!(name: 'Test group')
    product = ProductRequired.create(lato_spaces_group_id: lato_spaces_group.id)
    assert product.valid?
    assert_not product.lato_spaces_associations.empty?
    assert_not product.lato_spaces_groups.empty?

    # Test some methods of LatoSpaces::Associable and LatoSpaces::AssociableRequired.
    product = ProductRequired.find(product.id)
    assert_equal product.lato_spaces_group, lato_spaces_group
    assert_equal product.lato_spaces_group_id, lato_spaces_group.id
  end
end
