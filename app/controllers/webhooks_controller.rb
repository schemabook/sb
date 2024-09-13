class WebhooksController < ApplicationController
  def new
    @schema = @business.schemas.find_by!(public_id: params[:schema_public_id])

    redirect_to schema_path(@schema) unless @schema.team.users.include?(current_user)
    return unless @schema.team.users.include?(current_user)

    @webhook = Webhook.new(schema: @schema)
    @activities = @business.activity_log.for_schema(schema: @schema).limit(8)
  end

  def create
    @schema = @business.schemas.find_by(public_id: params[:schema_public_id])

    redirect_to schema_path(@schema) unless @schema.team.users.include?(current_user)
    return unless @schema.team.users.include?(current_user)

    @webhook = Webhook.new(schema: @schema, user: current_user, url: params[:webhook][:url])
    if @webhook.save
      Events::Webhooks::Created.new(record: @webhook, user: current_user).publish

      flash[:notice] = "Webhook #{@schema.webhooks.count} was created"
      redirect_to schema_path(@schema)
    else
      flash[:alert] = "There was an error saving the webhook, please try again"
      render :new
    end
  end

  private

  def webhook_params
    params.require(:webhook).permit(:url)
  end
end
