module LatoSpaces
  class MembershipsController < ApplicationController
    before_action :authenticate_lato_spaces_management
    # Each invitation sends an email: throttle per IP to limit abuse.
    before_action -> { limit_requests(20, 10.minutes) }, only: %i[create_action send_invite_action]
    before_action :find_group, only: %i[create create_action]
    before_action :find_membership, only: %i[destroy_action send_invite_action]

    def create
      @membership = @group.lato_spaces_memberships.new
    end

    def create_action
      @membership = @group.lato_spaces_memberships.new(membership_params)
      # Lato invitations bypass auth_disable_signup: only admins can invite unregistered emails then.
      @membership.invitations_disabled = Lato.config.auth_disable_signup && !@session.user.lato_spaces_admin

      respond_to do |format|
        if @membership.save
          notice = @membership.lato_invitation_id ? I18n.t('lato_spaces.flash.membership_invited') : I18n.t('lato_spaces.flash.membership_created')
          format.html { redirect_to lato_spaces.groups_show_path(@group), notice: notice }
          format.json { render json: @membership }
        else
          format.html { render :create, status: :unprocessable_entity }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_action
      respond_to do |format|
        if last_member_removal?
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), alert: I18n.t('lato_spaces.flash.membership_last_member') }
          format.json { render json: { error: I18n.t('lato_spaces.flash.membership_last_member') }, status: :unprocessable_entity }
        elsif @membership.destroy
          redirect = lato_spaces.groups_show_path(@membership.lato_spaces_group)
          redirect = lato_spaces.root_path if !@session.user.lato_spaces_admin && @membership.lato_user_id == @session.user_id

          format.html { redirect_to redirect, notice: I18n.t('lato_spaces.flash.membership_destroyed') }
          format.json { head :no_content }
        else
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), alert: I18n.t('lato_spaces.flash.membership_destroy_error') }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    def send_invite_action
      respond_to do |format|
        if @membership.send_invite
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), notice: I18n.t('lato_spaces.flash.invite_sent') }
          format.json { render json: @membership }
        else
          format.html { redirect_to lato_spaces.groups_show_path(@membership.lato_spaces_group), alert: I18n.t('lato_spaces.flash.invite_error') }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def membership_params
      params.require(:membership).permit(LatoSpaces.config.membership_params)
    end

    def find_group
      @group = accessible_spaces_groups.find(params[:group_id])
    end

    def find_membership
      @membership = LatoSpaces::Membership.where(lato_spaces_group_id: accessible_spaces_groups.select(:id)).find(params[:id])
    end

    # Non-admins can not leave a group without registered members: only admins could reach it.
    def last_member_removal?
      return false if @session.user.lato_spaces_admin
      return false if @membership.lato_user_id.blank?

      !LatoSpaces::Membership.where(lato_spaces_group_id: @membership.lato_spaces_group_id).where.not(id: @membership.id).where.not(lato_user_id: nil).exists?
    end
  end
end
