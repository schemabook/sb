class ProfilesController < ApplicationController
  before_action :set_user

  def show
    # TODO: retrieve activity of user
  end

  def edit
    require_admin_or_actual_user
  end

  def update
    require_admin_or_actual_user

    # process avatar

    if @user.update(profile_params)
      flash[:notice] = "User profile has been updated"

      Events::Users::Updated.new(user: @user).publish
    else
      flash[:warning] = "User profile has not been updated"
    end

    redirect_to user_profile_path(@user)
  end

  private

  def set_user
    @user = current_user.business.users.find(params[:id])
  end

  def profile_params
    params.require(:user).permit(:email, :first_name, :last_name, :team_id, :avatar)
  end

  def require_admin_or_actual_user
    redirect_to user_profile_path(current_user) unless current_user.admin? || current_user == @user
  end
end
