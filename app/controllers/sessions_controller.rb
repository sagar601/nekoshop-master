class SessionsController < Devise::SessionsController

  def new
    session[:return_to] = params[:return_to] if params.include? :return_to
    super
  end

  protected

  def after_sign_in_path_for resource
    session.delete(:return_to) || super
  end
end