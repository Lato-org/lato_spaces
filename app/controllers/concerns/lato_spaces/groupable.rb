module LatoSpaces::Groupable
  extend ActiveSupport::Concern

  def authenticate_group
    group_id = @session.get(:spaces_group_id)
    unless group_id.present? && accessible_spaces_groups.exists?(id: group_id)
      session_group_destroy if group_id.present?
      redirect_to lato_spaces.root_path
      return false
    end

    true
  end

  def session_group_create(group_id)
    group = accessible_spaces_groups.find_by(id: group_id)
    return false unless group

    session_update(spaces_group_id: group.id)
  end

  def session_group_destroy
    session_update(spaces_group_id: nil)
  end

  private

  def accessible_spaces_groups
    return LatoSpaces::Group.none unless @session.really_valid?
    return LatoSpaces::Group.all if @session.user.lato_spaces_admin

    LatoSpaces::Group.where(id: LatoSpaces::Membership.where(lato_user_id: @session.user_id).select(:lato_spaces_group_id))
  end
end
