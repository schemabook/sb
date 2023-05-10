class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.find_or_initialize_by(favorite_params)

    if @favorite.save
      flash[:notice] = "The schema has been starred"
    else
      flash[:alert] = "The schema could not be starred, please try again"
    end

    redirect_to dashboards_path
  end

  def destroy
    @favorite = current_user.favorites.find_by(favorite_params)

    if @favorite.destroy
      flash[:notice] = "The schema has been unstarred"
    else
      flash[:alert] = "The schema could not be unstarred, please try again"
    end

    redirect_to dashboards_path
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :schema_id)
  end
end
