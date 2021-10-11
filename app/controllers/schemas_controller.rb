class SchemasController < ApplicationController
  def new
    @schema = Schema.new
  end

  def show
    @schema  = current_user.team.schemas.where(id: params[:id]).first
    @tab     = params[:tab] || "json"
    @content = define_content(@tab)
  end

  def create
    @schema = Schema.new(schema_params)

    if @schema.save
      redirect_to schema_path(@schema)
    else
      render :new
    end
  end

  private

  def schema_params
    params.require(:schema).permit(:name).merge(team_id: current_user.team.id)
  end

  def define_content(tab)
    "this is the #{tab} content" unless tab == "info"
  end
end
