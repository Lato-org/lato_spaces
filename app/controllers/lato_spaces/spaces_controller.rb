module LatoSpaces
  class SpacesController < ApplicationController
    before_action :find_space, only: %i[update update_action destroy_action members members_create members_create_action]
    before_action :find_space_member, only: %i[members_send_invite_action members_destroy_action]

    def index
      columns = %i[name lato_space_members actions]
      sortable_columns = %i[name]
      searchable_columns = %i[name]

      @spaces = lato_index_collection(
        LatoSpaces::Space.all,
        columns: columns,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_sort_by: 'name|ASC',
        pagination: true
      )
    end

    def create
      @space = LatoSpaces::Space.new
    end

    def create_action
      @space = LatoSpaces::Space.new(space_params.merge(lato_user_creator_id: @session.user_id))
      
      respond_to do |format|
        if @space.save
          format.html { redirect_to lato_spaces.spaces_path, notice: 'Space was successfully created.' }
          format.json { render json: @space }
        else
          format.html { render :create, status: :unprocessable_entity }
          format.json { render json: @space.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
    end

    def update_action
      respond_to do |format|
        if @space.update(space_params)
          format.html { redirect_to lato_spaces.spaces_path, notice: 'Space was successfully updated.' }
          format.json { render json: @space }
        else
          format.html { render :update, status: :unprocessable_entity }
          format.json { render json: @space.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_action
      respond_to do |format|
        if @space.destroy
          format.html { redirect_to lato_spaces.spaces_path, notice: 'Space was successfully destroyed.' }
          format.json { render json: @space }
        else
          format.html { redirect_to lato_spaces.spaces_path, status: :unprocessable_entity, alert: @space.errors.full_messages.to_sentence }
          format.json { render json: @space.errors, status: :unprocessable_entity }
        end
      end
    end

    def members
      columns = %i[lato_user_id actions]
      sortable_columns = %i[]
      searchable_columns = %i[lato_user_id]

      @space_members = lato_index_collection(
        @space.lato_space_members,
        columns: columns,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_sort_by: 'lato_user_id|ASC',
        pagination: true
      )
    end

    def members_create
      @space_member = @space.lato_space_members.new
    end

    def members_create_action
      @space_member = @space.lato_space_members.new(space_member_params.merge(lato_user_creator_id: @session.user_id))

      respond_to do |format|
        if @space_member.save
          format.html { redirect_to lato_spaces.spaces_members_path(@space), notice: 'Member was successfully invited.' }
          format.json { render json: @space_member }
        else
          format.html { render :members_create, status: :unprocessable_entity }
          format.json { render json: @space_member.errors, status: :unprocessable_entity }
        end
      end
    end

    def members_send_invite_action
      respond_to do |format|
        if @space_member.send_invite
          format.html { redirect_to lato_spaces.spaces_members_path(@space), notice: 'Member was successfully invited.' }
          format.json { render json: @space_member }
        else
          format.html { redirect_to lato_spaces.spaces_members_path(@space), status: :unprocessable_entity, alert: @space_member.errors.full_messages.to_sentence }
          format.json { render json: @space_member.errors, status: :unprocessable_entity }
        end
      end
    end

    def members_destroy_action
      respond_to do |format|
        if @space_member.destroy
          format.html { redirect_to lato_spaces.spaces_members_path(@space), notice: 'Member was successfully removed.' }
          format.json { render json: @space_member }
        else
          format.html { redirect_to lato_spaces.spaces_members_path(@space), status: :unprocessable_entity, alert: @space_member.errors.full_messages.to_sentence }
          format.json { render json: @space_member.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def space_params
      params.require(:space).permit(:name)
    end

    def space_member_params
      params.require(:space_member).permit(:email)
    end

    def find_space
      @space = LatoSpaces::Space.find(params[:id])
    end

    def find_space_member
      @space_member = LatoSpaces::SpaceMember.find(params[:id])
    end
  end
end
