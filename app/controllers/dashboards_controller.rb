class DashboardsController < ApplicationController
  def index
    @activities = current_user.business.activity_log.activities.order(created_at: :desc).limit(8)
    @schemas    = current_user.business.teams.flat_map { |t| t.schemas }
  end
end
