module LatoSpaces
  module ApplicationHelper
    # The groups index is admin only: non-admins get breadcrumbs without it.
    def lato_spaces_breadcrumbs(*items)
      breadcrumbs = [{ label: I18n.t('lato_spaces.spaces'), path: lato_spaces.root_path }]
      breadcrumbs << { label: I18n.t('lato_spaces.groups'), path: lato_spaces.groups_path } if @session.user.lato_spaces_admin
      breadcrumbs + items
    end
  end
end
