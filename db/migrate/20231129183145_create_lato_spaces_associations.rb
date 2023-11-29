class CreateLatoSpacesAssociations < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_spaces_associations do |t|
      t.references :lato_spaces_group, foreign_key: { to_table: :lato_spaces_groups }
      t.references :item, polymorphic: true, null: false
      t.timestamps
    end
  end
end
