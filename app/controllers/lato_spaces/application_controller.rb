module LatoSpaces
  class ApplicationController < Lato::ApplicationController
    include LatoSpaces::Groupable

    layout 'lato/application'
    before_action :authenticate_session
    before_action { active_sidebar(:lato_spaces) }

    def index
      @groups = LatoSpaces::Group.joins(:lato_spaces_memberships).where(lato_spaces_memberships: { lato_user_id: @session.user_id }).order(name: :asc)
    end

    def setgroup
      respond_to do |format|
        if session_group_create(params[:id])
          format.html { redirect_to lato_spaces.root_path }
          format.json { render json: {} }
        else
          format.html { redirect_to lato_spaces.root_path, alert: 'Error on changing group.' }
          format.json { render json: { error: 'Error on changing group.' }, status: :unprocessable_entity }
        end
      end
    end

    protected

    def authenticate_lato_spaces_aadmin
      return true if @session.user.lato_spaces_admin

      redirect_to lato.root_path, alert: 'You have not access to this section.'
    end
  end
end