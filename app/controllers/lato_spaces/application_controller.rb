module LatoSpaces
  class ApplicationController < Lato::ApplicationController
    layout 'lato/application'
    before_action :authenticate_session
    before_action { active_sidebar(:lato_spaces) }

    def index
      redirect_to lato_spaces.groups_path
    end

    protected

    def authenticate_lato_spaces_aadmin
      return true if @session.user.lato_spaces_admin

      redirect_to lato.root_path, alert: 'You have not access to this section.'
    end
  end
end