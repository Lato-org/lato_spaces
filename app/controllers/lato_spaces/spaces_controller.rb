module LatoSpaces
  class SpacesController < ApplicationController
    before_action :find_space, only: %i[update update_action destroy_action]
    before_action :find_space_member, only: %i[]

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

    # def new
    #   @space = LatoSpaces::Space.new
    # end

    # def create
    #   @space = LatoSpaces::Space.new(space_params.merge(
    #     lato_user_creator_id: @session.user_id
    #   ))
    #   return render :new, status: :unprocessable_entity unless @space.save

    #   redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly created.'
    # end

    # def edit
    # end

    # def update
    #   return render :edit, status: :unprocessable_entity unless @space.update(space_params)

    #   redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly updated.'
    # end

    # def destroy
    #   @space.destroy
    #   redirect_to lato_spaces.spaces_path, notice: 'Spaces correctly destroyed.'
    # end

    # def members
    #   columns = %i[lato_user_id actions]
    #   sortable_columns = %i[]
    #   searchable_columns = %i[lato_user_id]

    #   @space_members = lato_index_collection(
    #     @space.lato_space_members,
    #     columns: columns,
    #     sortable_columns: sortable_columns,
    #     searchable_columns: searchable_columns,
    #     default_sort_by: 'lato_user_id|ASC',
    #     pagination: true
    #   )
    # end

    # def new_member
    #   @space_member = @space.lato_space_members.new
    # end

    # def create_member
    #   @space_member = @space.lato_space_members.new(space_member_params.merge(
    #     lato_user_creator_id: @session.user_id
    #   ))
    #   return render :new_member, status: :unprocessable_entity unless @space_member.save

    #   redirect_to lato_spaces.members_space_path(@space), notice: 'Member correctly created.'
    # end

    # def reinvite_member
    #   return redirect_to lato_spaces.members_space_path(@space_member.lato_space_id), status: :unprocessable_entity unless @space_member.lato_invitation
    #   return redirect_to lato_spaces.members_space_path(@space_member.lato_space_id), status: :unprocessable_entity, alert: @space_member.lato_invitation.errors.full_messages.to_sentence unless @space_member.lato_invitation.send_invite

    #   redirect_to lato_spaces.members_space_path(@space_member.lato_space_id), notice: 'Member correctly reinvited.'
    # end

    # def remove_member
    #   @space_member.destroy
    #   redirect_to lato_spaces.members_space_path(@space_member.lato_space_id), notice: 'Member correctly removed.'
    # end

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
