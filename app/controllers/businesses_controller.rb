class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:edit, :update, :destroy]

  def show
    @creator      = User.find(@business.created_by)
    @stakeholders = User.where(business_id: @business.id)
    @teams        = Team.where(business_id: @business.id)
    @activities   = @business.activity_log.for_business(business: @business).limit(8).reverse
  end

  def edit
    @creator      = User.find(@business.created_by)
    @stakeholders = User.where(business_id: @business.id)
  end

  def update
    respond_to do |format|
      if @business.update(business_params)
        Events::Businesses::Updated.new(business: @business, user: current_user).publish

        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @business.destroy

    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_business
    @business = current_user.business
  end

  def business_params
    params.require(:business).permit(:name, :street_address, :city, :state, :postal, :country)
  end
end
