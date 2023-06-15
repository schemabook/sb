class DashboardsController < ApplicationController
  def index
    @activities = @business.activity_log.activities.where(user_only: false).order(created_at: :desc).limit(8)
    @schemas = @business.teams.flat_map { |t| t.schemas }
    @favorite = Favorite.new
    @favorites = current_user.favorites

    @sorted_schemas = @favorites.map(&:schema) + @schemas.reject { |schema| @favorites.pluck(:schema_id).include?(schema.id) }
  end
end
