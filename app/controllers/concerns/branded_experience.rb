module BrandedExperience
  extend ActiveSupport::Concern

  included do
    before_action :create_branded_experience
  end

  def create_branded_experience
    return unless session_metadata
    @sp_logo = session_metadata[:logo]
    @sp_name = session_metadata[:name]
    @sp_return_url = session_metadata[:return_url]
  end

  def session_metadata
    session[:sp]
  end
end
