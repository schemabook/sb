class ApplicationController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!, except: [:registrations, :sessions]
  before_action :enable_search
  before_action :configure_permitted_parameters, if: :devise_controller?

  def enable_search
    @search_enabled = false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :business_id])
  end
end

