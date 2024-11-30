module LatoSpaces::Groupable
  extend ActiveSupport::Concern

  def authenticate_group
    if @session.get(:spaces_group_id).blank?
      redirect_to lato_spaces.root_path
      return false
    end

    true
  end

  def session_group_create(group_id)
    cookies.encrypted[:lato_session] = { value: Lato::Session.generate_session_per_user(@session.user_id, spaces_group_id: group_id), expires: Lato.config.session_lifetime.from_now }
    @session = Lato::Session.new(cookies.encrypted[:lato_session])

    true
  end

  def session_group_destroy
    cookies.encrypted[:lato_session] = { value: Lato::Session.generate_session_per_user(@session.user_id), expires: Lato.config.session_lifetime.from_now }
    @session = Lato::Session.new(cookies.encrypted[:lato_session])

    true
  end
end
