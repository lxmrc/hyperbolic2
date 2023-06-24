class ApplicationController < ActionController::Base
  impersonates :user
  include Pundit::Authorization

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username avatar])
  end

  def authenticate_admin!
    return if current_user&.admin?

    flash[:alert] = "You don't have permission to do that."
    redirect_to root_path
  end
end
