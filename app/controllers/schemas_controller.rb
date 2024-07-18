class SchemasController < ApplicationController
  def show
    @schema = current_user.team.schemas.find_by!(public_id: params[:public_id])
    @tab = params[:tab] || @schema.format.to_s
    @activities = @business.activity_log.for_schema(schema: @schema).limit(8)
    @stakeholder = Stakeholder.find_or_initialize_by(user_id: current_user.id, schema_id: @schema.id)
    @stakeholders = Stakeholder.where(schema_id: @schema.id)

    version_index = params[:version] || @schema.versions.last.index
    @version = @schema.versions.find_by(index: version_index)

    @comment = Comment.new(version: @version)
    @comments = @version.comments.order(created_at: :desc)

    load_presenters
  end

  def new
    @schema = Schema.new
    @activities = @business.activity_log.for_schema_new.limit(8)

    # flash message if business is unpaid and has 10 schemas
    flash[:alert] = "You've reached the limits of the free plan. Upgrade to a paid plan in your account settings to add more schemas." if at_limit?
  end

  # rubocop:disable Metrics/MethodLength
  def create
    _service = schema_params.key?(:service_id) && @business.services.find(schema_params[:service_id])

    @format = Format.create(format_params)
    @schema = Schema.new(schema_params.merge(format_id: @format.id))

    if at_limit?
      flash[:alert] = "You've reached the limits of the free plan. Upgrade to a paid plan in your account settings to add more schemas."
      @format.destroy

      render :new
    elsif @schema.save && (@version = create_version(schema: @schema))
      Events::Schemas::Created.new(record: @schema, user: current_user).publish

      flash[:info] = "Schema has been saved"
      redirect_to schema_path(@schema)
    else
      flash[:alert] = "Schema could not be saved; body contents were not valid"

      @schema.destroy if @schema.persisted?
      @format.destroy

      render :new
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def format_params
    params.require(:schema).permit(:file_type)
  end

  def schema_params
    params.require(:schema).permit(:name, :service_id, :description, :production).merge(team_id: current_user.team.id)
  end

  def version_params
    params.require(:schema).permit(:body)
  end

  def load_presenters
    @json_presenter = JsonPresenter.new(@schema, @version)
    @avro_presenter = AvroPresenter.new(@schema, @version)
    @csv_presenter = CsvPresenter.new(@schema, @version)
    @sql_presenter = SqlPresenter.new(@schema, @version)
  end

  def create_version(schema:)
    # NOTE: this will fail if the body contents are not valid for the format selected
    version = Version.new(version_params.merge(schema_id: schema.id).except(:body))
    version.body = version_params[:body]

    if version.valid?
      version.save

      version
    else
      flash[:alert] = "The schema is not formatted correctly and could not be saved." unless version.valid?

      false
    end
  end

  def at_limit?
    !@business.paid? && @business.schemas.size >= Schema::UNPAID_LIMIT
  end
end
