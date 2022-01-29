class ApplicationController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!, except: [:registrations, :sessions]
  before_action :enable_search
  before_action :configure_permitted_parameters, if: :devise_controller?

  def enable_search
    @search_enabled = false
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :business_id, :team_id])
    devise_parameter_sanitizer.permit(:profile_update, keys: [:email, :first_name, :last_name, :avatar, :team_id])
  end
end

