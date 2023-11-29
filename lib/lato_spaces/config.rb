module LatoSpaces
  # Config
  # This class contains the default configuration of the engine.
  ##
  class Config

    # Path of the redirect after set group.
    attr_accessor :setgroup_redirect_path

    # Icon of the group (bootstrap icon).
    attr_accessor :group_icon

    # Permit creation of groups for users.
    attr_accessor :permit_group_creation

    # Permit management of groups for users.
    attr_accessor :permit_group_management
    
    def initialize
      @setgroup_redirect_path = nil
      @group_icon = 'bi bi-people-fill'
      @permit_group_creation = false
      @permit_group_management = false
    end
  end
end