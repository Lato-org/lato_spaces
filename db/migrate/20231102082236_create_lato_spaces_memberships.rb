class CreateLatoSpacesMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :lato_spaces_memberships do |t|
      t.references :lato_spaces_group, foreign_key: { to_table: :lato_spaces_groups }
      t.references :lato_user, foreign_key: { to_table: :lato_users }
      t.references :lato_invitation, foreign_key: { to_table: :lato_invitations }
      t.timestamps
    end
  end
end
