class PublicController < ApplicationController
  layout 'public'

  skip_before_action :authenticate_user!

  def index
  end

  def features
  end

  def pricing
  end

  def docs
  end

  def company
  end

  def status
    render status: :ok
  end

  def privacy
  end

  def terms
  end
end
