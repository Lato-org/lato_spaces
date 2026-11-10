class AddUniqueIndexesToLatoSpaces < ActiveRecord::Migration[7.1]
  # Existing duplicates are removed before adding the unique indexes.
  # Duplicates are redundant rows: the kept row is the preferred one (memberships) or the oldest.
  def up
    deduplicate(:lato_spaces_memberships, %w[lato_spaces_group_id lato_user_id], 'preferred DESC, id ASC')
    deduplicate(:lato_spaces_memberships, %w[lato_spaces_group_id lato_invitation_id], 'id ASC')
    deduplicate(:lato_spaces_associations, %w[lato_spaces_group_id item_type item_id], 'id ASC')

    add_index :lato_spaces_memberships, %i[lato_spaces_group_id lato_user_id], unique: true, name: 'index_lato_spaces_memberships_on_group_and_user'
    add_index :lato_spaces_memberships, %i[lato_spaces_group_id lato_invitation_id], unique: true, name: 'index_lato_spaces_memberships_on_group_and_invitation'
    add_index :lato_spaces_associations, %i[lato_spaces_group_id item_type item_id], unique: true, name: 'index_lato_spaces_associations_on_group_and_item'
  end

  def down
    remove_index :lato_spaces_memberships, name: 'index_lato_spaces_memberships_on_group_and_user'
    remove_index :lato_spaces_memberships, name: 'index_lato_spaces_memberships_on_group_and_invitation'
    remove_index :lato_spaces_associations, name: 'index_lato_spaces_associations_on_group_and_item'
  end

  private

  # Raw SQL on purpose: model callbacks (e.g. AssociableRequired item destruction) must not run.
  def deduplicate(table, columns, keep_order)
    not_null = columns.map { |column| "#{column} IS NOT NULL" }.join(' AND ')
    duplicates = select_rows("SELECT #{columns.join(', ')} FROM #{table} WHERE #{not_null} GROUP BY #{columns.join(', ')} HAVING COUNT(*) > 1")

    duplicates.each do |values|
      conditions = columns.zip(values).map { |column, value| "#{column} = #{connection.quote(value)}" }.join(' AND ')
      ids = select_values("SELECT id FROM #{table} WHERE #{conditions} ORDER BY #{keep_order}")
      execute("DELETE FROM #{table} WHERE id IN (#{ids.drop(1).map { |id| connection.quote(id) }.join(', ')})")
    end
  end
end
