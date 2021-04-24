class ApplicationController < ActionController::Base
  layout 'application'

  before_action :authenticate_user!, except: [:registrations]

  before_action :enable_search

  def enable_search
    @search_enabled = false
  end
end

