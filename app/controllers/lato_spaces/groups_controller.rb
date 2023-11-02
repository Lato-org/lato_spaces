module LatoSpaces
  class GroupsController < ApplicationController
    before_action :find_group, only: %i[update update_action destroy_action]

    def index
      columns = %i[name actions]
      sortable_columns = %i[name]
      searchable_columns = %i[name]

      @groups = lato_index_collection(
        LatoSpaces::Group.all,
        columns: columns,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_sort_by: 'name|ASC',
        pagination: true
      )
    end

    def create
    end

    def create_action
    end

    def update
    end

    def update_action
    end

    def destroy_action
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end

    def find_group
      @space = LatoSpaces::Group.find(params[:id])
    end
  end
end