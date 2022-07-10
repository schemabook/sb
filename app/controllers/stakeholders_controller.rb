class StakeholdersController < ApplicationController
  def create
    @stakeholder = Stakeholder.new(stakeholder_params)

    if @stakeholder.save
      flash.now[:message] = "You have been added as a stakeholder"
    else
      flash.now[:alert] = "Could not be added as a stakeholder, please try again"
    end
  end

  private

  def stakeholder_params
    params.require(:stakeholder).permit(:user_id, :schema_id)
  end
end
