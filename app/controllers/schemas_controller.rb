class SchemasController < ApplicationController
  def new
    @schema     = Schema.new
    @activities = current_user.business.activity_log.for_schema_new.limit(8).reverse
  end

  def show
    @schema     = current_user.team.schemas.where(id: params[:id]).first
    @tab        = params[:tab] || @schema.format.to_s
    @activities = current_user.business.activity_log.for_schema(schema: @schema).limit(8).reverse
  end

  def create
    @format = Format.create(format_params)
    @schema = Schema.new(schema_params.merge(format_id: @format.id))

    if @schema.save
      Events::Schemas::Created.new(record: @schema, user: current_user).publish

      redirect_to schema_path(@schema)
    else
      flash.now[:alert] = "Schema could not be saved"
      @format.destroy

      render :new
    end
  end

  private

  def format_params
    params.require(:schema).permit(:file_type)
  end

  def schema_params
    params.require(:schema).permit(:name, :service_id, :file_type, :body, :description).merge(team_id: current_user.team.id)
  end
end
