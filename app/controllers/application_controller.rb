class ApplicationController < ActionController::Base
  layout "application"

  attr_accessor :business

  before_action :authenticate_user!, except: [:registrations, :sessions]
  before_action :enable_search
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_business

  def enable_search
    @search_enabled = false
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def set_business
    @business = current_user&.business

    return if !@business&.disabled? || !current_user

    ### NOTE: this is a hack to temporarily prevent bots from signing into spam accounts

    # log that a user tried to sign into a disabled business
    logger.info "#{current_user.email} tried signing into disabled #{@business.name} account"

    # sign user out if the business is disabled
    sign_out current_user

    # redirect to homepage
    redirect_to :root
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :business_id, :team_id])
    devise_parameter_sanitizer.permit(:profile_update, keys: [:email, :first_name, :last_name, :avatar, :team_id])
  end
end
