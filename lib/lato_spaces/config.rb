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

    # Params of the membership.
    attr_accessor :membership_params

    # Permit creation of groups for users.
    attr_accessor :permit_group_creation

    # Permit management of groups for users.
    attr_accessor :permit_group_management

    # Permit users to choose a preferred group.
    attr_accessor :permit_group_preferred
    
    def initialize
      @setgroup_redirect_path = nil
      @group_icon = 'bi bi-people-fill'
      @group_params = %i[name]
      @membership_params = %i[email]
      @permit_group_creation = false
      @permit_group_management = false
      @permit_group_preferred = false
    end
  end
end