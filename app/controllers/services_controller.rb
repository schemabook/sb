class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy]

  # GET /services or /services.json
  def index
    @services = @business.services
  end

  # GET /services/1 or /services/1.json
  def show
    @activities = @business.activity_log.for_service(service_id: @service.id).limit(8)
  end

  # GET /services/new
  def new
    @service = Service.new
    @activities = @business.activity_log.for_service_team(team: current_user.team).limit(8)

    # flash message if business is unpaid and has 10 services
    flash[:alert] = "You've reached the limits of the free plan. Upgrade to a paid plan in your account settings to add more services." if at_limit?
  end

  # TODO: scope to current user business
  # GET /services/1/edit
  def edit
    @activities = @business.activity_log.for_service(service_id: @service.id).limit(8)
  end

  # POST /services or /services.json
  # rubocop:disable Metrics/MethodLength
  def create
    if at_limit?
      @service = Service.new
      @activities = @business.activity_log.for_service_team(team: current_user.team).limit(8)

      flash[:alert] = "You've reached the limits of the free plan. Upgrade to a paid plan in your account settings to add more services."

      render :new
    else
      @service = Service.new(service_params.merge({team_id: current_user.team.id, created_by: current_user.id}))

      respond_to do |format|
        if @service.save
          Events::Services::Created.new(record: @service, user: current_user).publish

          format.html { redirect_to @service, notice: "Service was successfully created." }
          format.json { render :show, status: :created, location: @service }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @service.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: "Service was successfully updated." }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # TODO: use pluck instead of map
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    teams = @business.teams
    @service = Service.where(public_id: params[:id], team_id: teams.map(&:id)).first
  end

  # Only allow a list of trusted parameters through.
  def service_params
    params.require(:service).permit(:name, :description, :created_by)
  end

  def at_limit?
    !@business.paid? && @business.services.size >= Service::UNPAID_LIMIT
  end
end
