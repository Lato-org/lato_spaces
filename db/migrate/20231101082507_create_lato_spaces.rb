class CreateLatoSpaces < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_spaces do |t|
      t.string :name
      t.references :lato_user_creator, foreign_key: { to_table: :lato_users }
      t.timestamps
    end
  end
end
