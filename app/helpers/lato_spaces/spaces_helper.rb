module LatoSpaces
  module SpacesHelper
    def lato_spaces_space_lato_space_members(space)
      members = space.lato_space_members.map(&:full_name)
      label = members.count > 1 ? "#{members.first} + #{members.count - 1}" : members.first
      lato_data_user label
    end

    def lato_spaces_space_actions(space)
      content_tag(:div, class: 'btn-group btn-group-sm') do
        concat link_to('Members', lato_spaces.spaces_members_path(space), class: 'btn btn-primary')
        concat link_to('Edit', lato_spaces.spaces_update_path(space), class: 'btn btn-secondary', data: { lato_action_target: 'trigger', turbo_frame: dom_id(space, 'form'), action_title: 'Edit space' })
        concat link_to('Delete', lato_spaces.spaces_destroy_action_path(space), class: 'btn btn-danger', data: { turbo_confirm: 'Are you sure?', turbo_method: :delete, turbo_frame: '_top' })
      end
    end

    def lato_spaces_space_member_lato_user_id(space_member)
      infos = ''
      if space_member.lato_invitation
        infos = content_tag(:small, class: 'text-muted d-inline-block ms-1') do
          "(invited #{time_ago_in_words(space_member.lato_invitation.created_at)} ago)"
        end
      end

      content_tag(:div, class: 'd-flex align-items-center') do
        concat lato_data_user(space_member.full_name)
        concat infos
      end
    end

    def lato_spaces_space_member_actions(space_member)
      content_tag(:div, class: 'btn-group btn-group-sm') do
        if space_member.lato_invitation
          concat link_to('Resend', lato_spaces.reinvite_member_space_path(space_member), class: 'btn btn-primary', data: { turbo_method: :post })
        end
        concat link_to('Remove', lato_spaces.remove_member_space_path(space_member), class: 'btn btn-danger', data: { turbo_confirm: 'Are you sure?', turbo_method: :delete, turbo_frame: '_top' })
      end
    end
  end
end
