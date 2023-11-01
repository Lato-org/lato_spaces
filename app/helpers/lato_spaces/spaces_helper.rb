module LatoSpaces
  module SpacesHelper
    def lato_spaces_space_lato_space_members(space)
      members = space.lato_space_members.map(&:lato_user).map(&:full_name)
      label = members.count > 1 ? "#{members.first} + #{members.count - 1} members" : members.first
      lato_data_user label
    end

    def lato_spaces_space_actions(space)
      content_tag(:div, class: 'btn-group btn-group-sm') do
        concat link_to('Members', lato_spaces.members_space_path(space), class: 'btn btn-primary', data: { lato_action_target: 'trigger', turbo_frame: dom_id(space, 'members'), action_size: 'xl' })
        concat link_to('Edit', lato_spaces.edit_space_path(space), class: 'btn btn-secondary', data: { lato_action_target: 'trigger', turbo_frame: dom_id(space, 'form') })
        concat link_to('Delete', lato_spaces.space_path(space), class: 'btn btn-danger', data: { turbo_confirm: 'Are you sure?', turbo_method: :delete, turbo_frame: '_top' })
      end
    end
  end
end
