require "test_helper"

module LatoSpaces
  class AssociationTest < ActiveSupport::TestCase
    setup do
      # Load the strict models first: their concerns must not leak to Product.
      ProductRequired
      ProductUnique
      @group = LatoSpaces::Group.create!(name: "Group A")
      @other_group = LatoSpaces::Group.create!(name: "Group B")
    end

    test "removing an Associable-only item from a group keeps the item" do
      product = Product.create!
      assert product.add_to_lato_spaces_group(@group.id)

      assert product.remove_from_lato_spaces_group(@group.id)
      assert Product.exists?(product.id)
    end

    test "destroying a group keeps Associable-only items and destroys AssociableRequired items" do
      product = Product.create!
      product.add_to_lato_spaces_group(@group.id)
      product_required = ProductRequired.create!(lato_spaces_group_id: @group.id)

      @group.destroy!

      assert Product.exists?(product.id)
      assert_not ProductRequired.exists?(product_required.id)
    end

    test "Associable-only items can belong to many groups" do
      product = Product.create!
      assert product.add_to_lato_spaces_group(@group.id)
      assert product.add_to_lato_spaces_group(@other_group.id)
      assert_equal 2, product.lato_spaces_associations.count
    end

    test "AssociableUnique items reject a second group with an error" do
      product = ProductUnique.create!
      assert product.add_to_lato_spaces_group(@group.id)
      assert_not product.add_to_lato_spaces_group(@other_group.id)
      assert product.errors[:base].any?
      assert_equal 1, product.lato_spaces_associations.count
    end

    test "add_to_lato_spaces_group returns false on duplicate association" do
      product = Product.create!
      assert product.add_to_lato_spaces_group(@group.id)
      assert_not product.add_to_lato_spaces_group(@group.id)
    end

    test "AssociableRequired rejects a nonexistent group" do
      product = ProductRequired.create(lato_spaces_group_id: 999_999)
      assert_not product.persisted?
      assert product.errors[:lato_spaces_group_id].any?
    end

    test "AssociableRequired creates the association" do
      product = ProductRequired.create!(lato_spaces_group_id: @group.id)
      assert_equal @group, ProductRequired.find(product.id).lato_spaces_group
      assert_includes ProductRequired.for_lato_spaces_group(@group.id), product
    end

    test "removing an AssociableRequired item from its group destroys it" do
      product = ProductRequired.create!(lato_spaces_group_id: @group.id)
      product.remove_from_lato_spaces_group(@group.id)
      assert_not ProductRequired.exists?(product.id)
    end

    test "switch_lato_spaces_group moves the item and refreshes cached group" do
      product = ProductUnique.create!
      product.add_to_lato_spaces_group(@group.id)
      assert_equal @group.id, product.lato_spaces_group_id

      assert product.switch_lato_spaces_group(@other_group.id)
      assert_equal @other_group.id, product.lato_spaces_group_id
    end

    test "for_lato_spaces_group with nil returns nothing" do
      Product.create!.add_to_lato_spaces_group(@group.id)
      assert_empty Product.for_lato_spaces_group(nil)
    end
  end
end
