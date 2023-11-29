Lato.configure do |config|
  config.application_title = 'Lato example app'
  config.application_version = LatoSpaces::VERSION

  config.session_root_path = :documentation_path
end

LatoSpaces.configure do |config|
  config.create_default_group = true
  config.create_default_group_name = 'My group'
  config.permit_group_creation = true
  config.permit_group_management = true
end
