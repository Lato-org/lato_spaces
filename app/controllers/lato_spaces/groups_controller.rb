module LatoSpaces
  class GroupsController < ApplicationController
    before_action :find_group, only: %i[show update_action destroy_action]

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
      @group = LatoSpaces::Group.new
    end

    def create_action
      @group = LatoSpaces::Group.new(group_params)

      respond_to do |format|
        if @group.save
          format.html { redirect_to lato_spaces.groups_show_path(@group), notice: 'Group was successfully created.' }
          format.json { render json: @group }
        else
          format.html { render :create, status: :unprocessable_entity }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
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
      @group = LatoSpaces::Group.find(params[:id])
    end
  end
end