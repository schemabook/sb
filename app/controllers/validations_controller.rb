# TODO: move to a proper API, rather than a buried controller
class ValidationsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    schema  = Schema.find_by!(public_id: params[:schema_public_id])
    payload = params[:payload]

    # validate
    if PayloadValidator.new(schema:, payload:).valid?
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
