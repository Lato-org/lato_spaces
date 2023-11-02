module LatoSpaces
  module MembershipsHelper
    def lato_spaces_membership_user_infos(membership)
      infos = ''
      if membership.lato_invitation
        infos = content_tag(:small, class: 'text-muted d-inline-block ms-1') do
          "(invited #{time_ago_in_words(membership.lato_invitation.created_at)} ago)"
        end
      end

      content_tag(:div, class: 'd-flex align-items-center') do
        concat lato_data_user(membership.user_infos_label)
        concat infos
      end
    end

    def lato_spaces_membership_actions(membership)
      content_tag(:div, class: 'btn-group btn-group-sm') do
        if membership.lato_invitation
          concat link_to('Resend', lato_spaces.memberships_send_invite_action_path(membership), class: 'btn btn-primary', data: { turbo_confirm: 'Are you sure?', turbo_method: :post })
        end
        concat link_to('Delete', lato_spaces.memberships_destroy_action_path(membership), class: 'btn btn-danger', data: { turbo_confirm: 'Are you sure?', turbo_method: :delete })
      end
    end
  end
end
