class DashboardsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  def index
    @activities = @business.activity_log.activities.where(user_only: false).order(created_at: :desc).limit(8)

    sort_column = params[:sort] || "created_at"
    sort_direction = params[:direction].presence_in(%w[asc desc]) || "desc"
    @schemas = Schema.where(team_id: @business.teams.pluck(:id)).order("#{sort_column} #{sort_direction}").page(page_param).per(20)

    @favorite = Favorite.new
    @favorites = current_user.favorites

    schemas = favorite_schemas + @schemas.reject { |schema| @favorites.pluck(:schema_id).include?(schema.id) }
    @sorted_schemas = sort(schemas, sort_order)

    # for pagination
    collection = Schema.where(team_id: @business.teams.pluck(:id)).page(page_param).per(20)
    @total_pages = collection.total_pages
    @current_page = collection.current_page
    @next_page = collection.next_page
    @previous_page = collection.prev_page
  end
  # rubocop:enable Metrics/MethodLength

  private

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def sort(schemas, sort_order)
    case sort_order
    when "alphabetically"
      schemas.sort_by { |schema| schema.name.downcase }
    when "chronologically"
      schemas.sort_by { |schema| schema.created_at }
    when "services"
      schemas.sort_by { |schema| schema.service&.name.nil? ? "" : schema.service&.name&.downcase }
    when "stakeholder"
      schemas.sort_by { |schema| schema.stakeholders.map(&:user_id).include?(@current_user.id) ? 0 : 1 }
    else
      schemas
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def sort_order
    params[:sort]
  end

  def favorite_schemas
    @favorites.map(&:schema)
  end

  def page_param
    params[:page]
  end

  def dashboard_params
    params.permit(:sort, :page)
  end
end
