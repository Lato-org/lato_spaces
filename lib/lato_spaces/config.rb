module LatoSpaces
  # Config
  # This class contains the default configuration of the engine.
  ##
  class Config

    # Path of the redirect after set group.
    attr_accessor :setgroup_redirect_path

    # Auto-select first group after login.
    # NOTE: Requires to set `setgroup_redirect_path` to work properly.
    attr_accessor :setgroup_auto_after_login

    # Auto-select first group after login only if user has a single group.
    # NOTE: Requires to set `setgroup_redirect_path` to work properly.
    attr_accessor :setgroup_auto_after_login_if_single

    # Icon of the group (bootstrap icon).
    attr_accessor :group_icon

    # Params of the group.
    attr_accessor :group_params

    # Params of the membership.
    attr_accessor :membership_params

    # Permit creation of groups for users (not admins).
    attr_accessor :permit_group_creation

    # Permit management of groups for users (not admins).
    attr_accessor :permit_group_management

    # Permit users to choose a preferred group.
    attr_accessor :permit_group_preferred
    
    def initialize
      @setgroup_redirect_path = nil
      @setgroup_auto_after_login = false
      @setgroup_auto_after_login_if_single = false
      @group_icon = 'bi bi-people-fill'
      @group_params = %i[name]
      @membership_params = %i[email]
      @permit_group_creation = false
      @permit_group_management = false
      @permit_group_preferred = false
    end
  end
end