module LatoSpaces
  class GroupsController < ApplicationController
    before_action :authenticate_lato_spaces_admin, only: %i[index]
    before_action :authenticate_lato_spaces_creation, only: %i[create create_action]
    before_action :authenticate_lato_spaces_management, only: %i[show update update_action destroy_action]
    before_action :find_group, only: %i[show update update_action destroy_action]

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
        if @group.save && @group.lato_spaces_memberships.create(lato_user_id: @session.user_id)
          redirect = lato_spaces.groups_show_path(@group)
          redirect = lato_spaces.root_path unless @session.user.lato_spaces_admin

          format.html { redirect_to redirect, notice: 'Group was successfully created.' }
          format.json { render json: @group }
        else
          format.html { render :create, status: :unprocessable_entity }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    def show
      columns = %i[user_infos actions]
      sortable_columns = %i[user_infos]
      searchable_columns = %i[user_infos]

      @memberships = lato_index_collection(
        @group.lato_spaces_memberships,
        columns: columns,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_sort_by: 'user_infos|ASC',
        pagination: true
      )
    end

    def update
    end

    def update_action
      respond_to do |format|
        if @group.update(group_params)
          format.html { redirect_to lato_spaces.groups_show_path(@group), notice: 'Group was successfully updated.' }
          format.json { render json: @group }
        else
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_action
      respond_to do |format|
        if @group.destroy
          redirect = lato_spaces.groups_path
          redirect = lato_spaces.root_path unless @session.user.lato_spaces_admin

          format.html { redirect_to redirect, notice: 'Group was successfully destroyed.' }
          format.json { render json: @group }
        else
          format.html { redirect_to lato_spaces.groups_show_path(@group), notice: 'Group was not destroyed.' }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end

    def find_group
      query = LatoSpaces::Group.all
      query = query.joins(:lato_spaces_memberships).where(lato_spaces_memberships: { lato_user_id: @session.user_id }) unless @session.user.lato_spaces_admin
      @group = query.find(params[:id])
    end
  end
end