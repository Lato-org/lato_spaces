class AddLatoSpacesAccessToLatoUser < ActiveRecord::Migration[7.1]
  def change
    add_column :lato_users, :lato_spaces_access, :boolean, default: false
  end
end
