module LatoSpaces
  class ApplicationController < Lato::ApplicationController
    layout 'lato/application'
    before_action :authenticate_session
    before_action { active_sidebar(:lato_spaces) }

    def index
      redirect_to lato_spaces.spaces_path
    end
  end
end
