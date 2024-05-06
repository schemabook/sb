class BusinessesController < ApplicationController
  before_action :require_admin, only: [:edit, :update, :destroy]

  def show
    @creator = User.find(@business.created_by)
    @stakeholders = User.where(business_id: @business.id)
    @teams = Team.where(business_id: @business.id)
    @activities = @business.activity_log.for_business(business: @business).limit(8)

    return unless @business.subscription_id

    subscription = Stripe::Subscription.retrieve @business.subscription_id

    @cancelled = subscription[:ended_at].nil? ? nil : Time.at(subscription[:ended_at]).utc.to_date
    @days_until_due = subscription[:days_until_due]
    @next_bill_date = Time.zone.today + @days_until_due.to_i.days
  end

  def edit
    @creator = User.find(@business.created_by)
    @stakeholders = User.where(business_id: @business.id)
    @activities = @business.activity_log.activities.limit(8)
  end

  def update
    respond_to do |format|
      if @business.update(business_params)
        Events::Businesses::Updated.new(business: @business, user: current_user).publish

        format.html { redirect_to @business, notice: "Business was successfully updated." }
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
      format.html { redirect_to businesses_url, notice: "Business was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :street_address, :city, :state, :postal, :country)
  end
end
