class CreateLatoSpacesSpaces < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_spaces_spaces do |t|
      t.string :name
      t.timestamps
    end
  end
end
