class VersionsController < ApplicationController
  def new
    @schema = Schema.find params[:schema_id]

    redirect_to schema_path(@schema) unless @schema.team.users.include?(current_user)
    return unless @schema.team.users.include?(current_user)

    @version    = Version.new(schema: @schema)
    @activities = current_user.business.activity_log.for_schema(schema: @schema).limit(8)
  end

  def create
    @schema = Schema.find params[:schema_id]

    redirect_to schema_path(@schema) unless @schema.team.users.include?(current_user)
    return unless @schema.team.users.include?(current_user)

    @version = Version.new(schema: @schema)
    if @version.save
      @version.body = version_params[:body]

      flash[:notice] = "Version #{@schema.versions.count} was created"
      redirect_to schema_path(@schema)
    else
      flash[:alert] = "There was an error saving the version, please try again"
      render :new
    end
  end

  private

  def version_params
    params.require(:version).permit(:body)
  end
end
