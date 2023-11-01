class CreateLatoSpacesSpaceMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_space_members do |t|
      t.references :lato_space, foreign_key: { to_table: :lato_spaces }
      t.references :lato_user, foreign_key: { to_table: :lato_users }
      t.timestamps
    end
  end
end
