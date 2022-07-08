class DashboardsController < ApplicationController
  def index
    @activities = current_user.business.activity_log.activities.limit(8).reverse
    @schemas    = current_user.business.teams.flat_map { |t| t.schemas }
  end
end
