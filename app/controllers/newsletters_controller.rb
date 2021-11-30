class NewslettersController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @newsletter = Newsletter.new(email: newsletter_params)

    respond_to do |format|
      if @newsletter.save
        format.json { render json: @newsletter, status: :created }
      else
        format.json { render json: @newsletter.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def newsletter_params
    params.require(:emailAddress)
  end
end
