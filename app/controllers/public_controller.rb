class PublicController < ApplicationController
  layout 'public'

  skip_before_action :authenticate_user!

  def index
  end

  def features
  end

  def pricing
  end

  def company
  end
end
