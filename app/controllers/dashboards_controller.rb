class DashboardsController < ApplicationController
  def index
    @activities = current_user.business.activity_log.activities.limit(8).reverse
  end
end
