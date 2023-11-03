class ApplicationController < LatoSpaces::ApplicationController
  include LatoSpaces::Groupable

  layout 'lato/application'
  before_action :authenticate_session, except: [:index]
  before_action :authenticate_group, except: [:index]

  def index
    redirect_to lato.root_path
  end

  def documentation
    active_sidebar(:documentation)
  end
end
