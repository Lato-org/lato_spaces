module LatoSpaces
  # Config
  # This class contains the default configuration of the engine.
  ##
  class Config

    # Path of the redirect after set group.
    attr_accessor :setgroup_redirect_path

    # Icon of the group (bootstrap icon).
    attr_accessor :group_icon

    # Params of the group.
    attr_accessor :group_params

    # Permit creation of groups for users.
    attr_accessor :permit_group_creation

    # Permit management of groups for users.
    attr_accessor :permit_group_management
    
    def initialize
      @setgroup_redirect_path = nil
      @group_icon = 'bi bi-people-fill'
      @group_params = %i[name]
      @permit_group_creation = false
      @permit_group_management = false
    end
  end
end