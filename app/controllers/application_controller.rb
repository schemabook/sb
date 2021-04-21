class ApplicationController < ActionController::Base
  layout 'application'

  # TODO: enable for all pages except sign_in and sign_up
  #before_action :authenticate_user!
end
