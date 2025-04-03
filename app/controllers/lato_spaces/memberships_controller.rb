module LatoSpaces
  class MembershipsController < ApplicationController
    before_action :authenticate_lato_spaces_management
    before_action :find_group, only: %i[create create_action]
    before_action :find_membership, only: %i[destroy_action send_invite_action]

    def create
      @membership = @group.lato_spaces_memberships.new
    end

    def create_action
      @membership = @group.lato_spaces_memberships.new(membership_params)

      respond_to do |format|
        if @membership.save
          format.html { redirect_to lato_spaces.groups_show_path(@group), notice: 'Membership was successfully created.' }
          format.json { render json: @membership }
        else
          format.html { render :create, status: :unprocessable_entity }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_action
      respond_to do |format|
        if @membership.destroy
          redirect = lato_spaces.groups_show_path(@membership.lato_spaces_group)
          redirect = lato_spaces.root_path if !@session.user.lato_spaces_admin && @membership.lato_user_id == @session.user_id

          format.html { redirect_to redirect, notice: 'Membership was successfully destroyed.' }
          format.json { head :no_content }
        else
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), notice: 'Membership was not destroyed.' }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    def send_invite_action
      respond_to do |format|
        if @membership.send_invite
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), notice: 'Invite was successfully sent.' }
          format.json { render json: @membership }
        else
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), notice: 'Invite was not sent.' }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def membership_params
      params.require(:membership).permit(LatoSpaces.config.membership_params)
    end

    def find_group
      query = LatoSpaces::Group.all
      query = query.joins(:lato_spaces_memberships).where(lato_spaces_memberships: { lato_user_id: @session.user_id }) unless @session.user.lato_spaces_admin
      @group = query.find(params[:group_id])
    end

    def find_membership
      @membership = LatoSpaces::Membership.find(params[:id])
    end
  end
end