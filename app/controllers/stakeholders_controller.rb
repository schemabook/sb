class StakeholdersController < ApplicationController
  def create
    _schema = current_user.business.schemas.find(stakeholder_params[:schema_id]) if stakeholder_params.key?(:schema_id)

    @stakeholder = Stakeholder.new(stakeholder_params)

    if @stakeholder.save
      Events::Stakeholders::Created.new(record: @stakeholder).publish

      flash.now[:message] = "You have been added as a stakeholder"
      render json: @stakeholder, status: :ok
    else
      flash.now[:alert] = "Could not be added as a stakeholder, please try again"
      render json: @stakeholder, status: :internal_server_error
    end
  end

  private

  def stakeholder_params
    params.require(:stakeholder).permit(:user_id, :schema_id)
  end
end
