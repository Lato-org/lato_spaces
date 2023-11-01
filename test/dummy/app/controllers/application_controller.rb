class ApplicationController < ActionController::Base
  def index
    redirect_to lato.root_path
  end
end
