class SchemasController < ApplicationController
  def new
    @schema     = Schema.new
    @activities = current_user.business.activity_log.for_schema_new.limit(8)
  end

  def show
    @schema       = current_user.team.schemas.where(id: params[:id]).first
    @tab          = params[:tab] || @schema.format.to_s
    @activities   = current_user.business.activity_log.for_schema(schema: @schema).limit(8)
    @stakeholder  = Stakeholder.find_or_initialize_by(user_id: current_user.id, schema_id: @schema.id)
    @stakeholders = Stakeholder.where(schema_id: @schema.id)

    version_id    = params[:version_id] || @schema.versions.last.id
    @version      = @schema.versions.find version_id

    # TODO: figure out how versions are going to work on show
    @comment      = Comment.new(version_id: @schema.versions.last.id)
    @comments     = @schema.versions.last.comments.order(created_at: :desc)

    load_presenters
  end

  def create
    @format = Format.create(format_params)
    @schema = Schema.new(schema_params.merge(format_id: @format.id))

    if @schema.save
      @version = create_version(schema: @schema)

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
    params.require(:schema).permit(:name, :service_id, :description).merge(team_id: current_user.team.id)
  end

  def version_params
    params.require(:schema).permit(:body)
  end

  def load_presenters
    @json_presenter = JsonPresenter.new(@schema, @version)
    @avro_presenter = AvroPresenter.new(@schema, @version)
    @csv_presenter  = CsvPresenter.new(@schema, @version)
  end

  def create_version(schema:)
    version = Version.create(version_params.merge(schema_id: schema.id).except(:body))
    # TODO: make sure body isn't wrapped in quotes, maybe sanitize
    version.body = version_params[:body]

    version
  end
end
