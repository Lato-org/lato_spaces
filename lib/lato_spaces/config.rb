module LatoSpaces
  # Config
  # This class contains the default configuration of the engine.
  ##
  class Config

    # Path of the redirect after set group.
    attr_accessor :setgroup_redirect_path

    # Icon of the group (bootstrap icon).
    attr_accessor :group_icon

    # Create a default group on user creation.
    attr_accessor :create_default_group, :create_default_group_name

    # Permit creation of groups for users.
    attr_accessor :permit_group_creation

    # Permit management of groups for users.
    attr_accessor :permit_group_management
    
    def initialize
      @setgroup_redirect_path = nil
      @group_icon = 'bi bi-people-fill'
      @create_default_group = false
      @create_default_group_name = 'Personal'
      @permit_group_creation = false
      @permit_group_management = false
    end
  end
end