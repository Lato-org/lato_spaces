module LatoSpaces
  # Config
  # This class contains the default configuration of the engine.
  ##
  class Config

    # Path of the redirect after set group.
    attr_accessor :setgroup_redirect_path

    # Icon of the group (bootstrap icon).
    attr_accessor :group_icon
    
    def initialize
      @setgroup_redirect_path = nil
      @group_icon = 'bi bi-people-fill'
    end
  end
end