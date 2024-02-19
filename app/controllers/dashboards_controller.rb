class DashboardsController < ApplicationController
  def index
    @activities = @business.activity_log.activities.where(user_only: false).order(created_at: :desc).limit(8)

    @schemas = @business.teams.flat_map { |t| t.schemas }

    @favorite = Favorite.new
    @favorites = current_user.favorites
    
    schemas = favorite_schemas + @schemas.reject { |schema| @favorites.pluck(:schema_id).include?(schema.id) }
    @sorted_schemas = sort(schemas, sort_order)
  end

  private

  def sort(schemas, sort_order)
    case sort_order
    when "alphabetically"
      schemas.sort_by { |schema| schema.name.downcase } 
    when "chronologically"
      schemas.sort_by { |schema| schema.created_at } 
    when "services"
      schemas.sort_by { |schema| schema.service&.name.nil? ? "" : schema.service&.name.downcase } 
    when "stakeholder"
      schemas.sort_by { |schema| schema.stakeholders.map(&:user_id).include?(@current_user.id) ? 0 : 1 } 
    else
      schemas
    end
  end

  def sort_order
    params[:sort]
  end

  def favorite_schemas
    @favorites.map(&:schema)
  end

  def dashboard_params
    params.permit(:sort)
  end
end
