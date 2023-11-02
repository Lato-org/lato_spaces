module LatoSpaces::Groupable
  extend ActiveSupport::Concern

  def authenticate_group
    redirect_to lato_spaces.root_path # TODO
  end
end
