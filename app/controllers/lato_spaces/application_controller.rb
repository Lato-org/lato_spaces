module LatoSpaces
  class ApplicationController < Lato::ApplicationController
    include LatoSpaces::Groupable

    layout 'lato/application'
    before_action :authenticate_session
    before_action { active_sidebar(:lato_spaces); active_navbar(:lato_spaces) }

    def index
      @memberships = LatoSpaces::Membership.where(lato_user_id: @session.user_id).order(created_at: :desc)
      @groups = LatoSpaces::Group.joins(:lato_spaces_memberships).where(lato_spaces_memberships: { lato_user_id: @session.user_id }).order(name: :asc)

      auto_select_group if auto_select_group?
    end

    def setgroup
      respond_to do |format|
        if session_group_create(params[:id])
          format.html { redirect_to setgroup_success_path, notice: I18n.t('lato_spaces.flash.group_selected') }
          format.json { render json: {} }
        else
          format.html { redirect_to lato_spaces.root_path, alert: I18n.t('lato_spaces.flash.group_select_error') }
          format.json { render json: { error: I18n.t('lato_spaces.flash.group_select_error') }, status: :unprocessable_entity }
        end
      end
    end

    def setpreferred
      membership = LatoSpaces::Membership.find_by(lato_user_id: @session.user_id, lato_spaces_group_id: params[:id])

      respond_to do |format|
        if membership&.set_preferred
          format.html { redirect_to lato_spaces.root_path }
          format.json { render json: {} }
        else
          format.html { redirect_to lato_spaces.root_path, alert: I18n.t('lato_spaces.flash.preferred_error') }
          format.json { render json: { error: I18n.t('lato_spaces.flash.preferred_error') }, status: :unprocessable_entity }
        end
      end
    end

    protected

    def authenticate_lato_spaces_admin
      return true if @session.user.lato_spaces_admin

      redirect_to lato.root_path, alert: I18n.t('lato_spaces.flash.access_denied')
    end

    def authenticate_lato_spaces_creation
      return true if LatoSpaces.config.permit_group_creation
      return true if @session.user.lato_spaces_admin

      redirect_to lato_spaces.root_path, alert: I18n.t('lato_spaces.flash.access_denied')
    end

    def authenticate_lato_spaces_management
      return true if LatoSpaces.config.permit_group_management
      return true if @session.user.lato_spaces_admin

      redirect_to lato_spaces.root_path, alert: I18n.t('lato_spaces.flash.access_denied')
    end

    private

    def auto_select_group?
      return false unless LatoSpaces.config.setgroup_redirect_path
      return false if @session.get(:spaces_group_id).present?

      LatoSpaces.config.setgroup_auto_after_login ||
        (LatoSpaces.config.setgroup_auto_after_login_if_single && @groups.size == 1)
    end

    # Preferred group first, then the first group by name.
    def auto_select_group
      group_id = @memberships.find(&:preferred)&.lato_spaces_group_id || @groups.first&.id
      redirect_to setgroup_success_path if group_id && session_group_create(group_id)
    end

    def setgroup_success_path
      return lato_spaces.root_path unless LatoSpaces.config.setgroup_redirect_path

      Rails.application.routes.url_helpers.public_send(LatoSpaces.config.setgroup_redirect_path)
    end
  end
end
