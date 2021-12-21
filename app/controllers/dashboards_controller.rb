class DashboardsController < ApplicationController
  def index
    binding.pry
    @activities = current_user.business.activity_log.activities
  end
end
