class ApplicationController < ActionController::Base
  include UserMessage
  include DeviseGuestSupport
  include FormBuilderExtensions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # log authorization violations but redirect the user to the login page because most common case is an expired session
  Rails.env.production? and rescue_from AuthService::UnauthorizedActionError do |error|
    Rails.logger.warn "Unauthorized Action Blocked: user #{error.user_id} tried to execute restricted action #{error.action}."
    redirect_to new_user_session_url
  end

  # allow `name` attribute to pass during signup
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
