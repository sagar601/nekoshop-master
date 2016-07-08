class RegistrationsController < Devise::RegistrationsController

  def new
    session[:return_to] = params[:return_to] if params.include? :return_to
    super
  end

  protected

  def after_sign_up_path_for resource
    session.delete(:return_to) || root_path
  end

  def after_inactive_sign_up_path_for resource
    root_path
  end
end