Lato.configure do |config|
  config.application_title = 'Lato example app'
  config.application_version = LatoSpaces::VERSION

  config.session_root_path = :documentation_path
end

LatoSpaces.configure do |config|
  config.setgroup_auto_after_login_if_single = true
  config.setgroup_redirect_path = :documentation_path
  config.permit_group_creation = true
  config.permit_group_management = true
  config.permit_group_preferred = true
end
