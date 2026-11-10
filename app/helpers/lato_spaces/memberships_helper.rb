module LatoSpaces
  module MembershipsHelper
    def lato_spaces_membership_user_infos(membership)
      infos = ''
      if membership.lato_invitation
        infos = content_tag(:span, class: 'badge text-bg-secondary ms-2') do
          I18n.t('lato_spaces.invitation_pending', time: time_ago_in_words(membership.lato_invitation.created_at))
        end
      end

      content_tag(:div, class: 'd-flex align-items-center') do
        concat lato_data_user(lato_spaces_membership_label(membership))
        concat infos
      end
    end

    def lato_spaces_membership_actions(membership)
      label = lato_spaces_membership_label(membership)
      destroy_confirm = if membership.lato_user_id.present? && membership.lato_user_id == @session.user_id
                          I18n.t('lato_spaces.confirm.membership_leave')
                        else
                          I18n.t('lato_spaces.confirm.membership_destroy', name: label)
                        end

      content_tag(:div, class: 'btn-group btn-group-sm') do
        if membership.lato_invitation
          concat link_to(I18n.t('lato_spaces.cta_resend'), lato_spaces.memberships_send_invite_action_path(membership), class: 'btn btn-primary', aria: { label: I18n.t('lato_spaces.aria.resend_invitation', name: label) }, data: { turbo_confirm: I18n.t('lato_spaces.confirm.invite_resend', name: label), turbo_method: :post })
        end
        concat link_to(I18n.t('lato_spaces.cta_delete'), lato_spaces.memberships_destroy_action_path(membership), class: 'btn btn-danger', aria: { label: I18n.t('lato_spaces.aria.remove_member', name: label) }, data: { turbo_confirm: destroy_confirm, turbo_method: :delete })
      end
    end

    private

    # Full names of registered users are shown to admins only, so adding an email does not reveal who owns it.
    def lato_spaces_membership_label(membership)
      membership.user_infos_label(show_name: @session.user.lato_spaces_admin)
    end
  end
end
