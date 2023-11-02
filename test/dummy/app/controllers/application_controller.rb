class ApplicationController < LatoSpaces::ApplicationController
  include LatoSpaces::Groupable

  layout 'lato/application'
  before_action :authenticate_session, only: [:protected]
  before_action :authenticate_group, only: [:protected]

  def index
    redirect_to lato.root_path
  end

  def protected
    active_sidebar(:protected)
  end
end
