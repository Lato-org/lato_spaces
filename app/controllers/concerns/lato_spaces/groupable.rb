module LatoSpaces::Groupable
  extend ActiveSupport::Concern

  # Protected: callable from host controllers and before_action, never routable as actions.
  protected

  def authenticate_group
    group_id = @session.get(:spaces_group_id)
    return true if group_id.present? && accessible_spaces_groups.exists?(id: group_id)

    session_group_destroy if group_id.present?
    respond_to do |format|
      format.html { redirect_to lato_spaces.root_path }
      format.json { head :forbidden }
    end

    false
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
