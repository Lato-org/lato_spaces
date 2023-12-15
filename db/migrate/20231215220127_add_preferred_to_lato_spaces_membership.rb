class AddPreferredToLatoSpacesMembership < ActiveRecord::Migration[7.1]
  def change
    add_column :lato_spaces_memberships, :preferred, :boolean, default: false
  end
end
