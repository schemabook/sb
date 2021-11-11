class SchemasController < ApplicationController
  def new
    @schema = Schema.new
  end

  def show
    @schema  = current_user.team.schemas.where(id: params[:id]).first
    @tab     = params[:tab] || "json"
  end

  def create
    @format = Format.create(format_params)
    @schema = Schema.new(schema_params.merge(format_id: @format.id))

    if @schema.save
      redirect_to schema_path(@schema)
    else
      render :new
    end
  end

  private

  def format_params
    params.require(:schema).permit(:file_type)
  end

  def schema_params
    params.require(:schema).permit(:name, :service_id, :file_type, :body).merge(team_id: current_user.team.id)
  end
end
