module LatoSpaces
  module GroupsHelper
    def lato_spaces_group_actions(group)
      content_tag(:div, class: 'btn-group btn-group-sm') do
        concat link_to('View', lato_spaces.groups_show_path(group), class: 'btn btn-primary')
      end
    end
  end
end
