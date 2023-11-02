class CreateLatoSpacesGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_spaces_groups do |t|
      t.string :name
      t.timestamps
    end
  end
end
