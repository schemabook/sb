class DashboardsController < ApplicationController
  def index
    @activities = current_user.business.activity_log.activities.reverse
  end
end
