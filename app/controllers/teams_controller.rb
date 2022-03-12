class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy]
  before_action :require_admin, only: [:new, :edit, :create, :update, :destroy]

  # NOTE: shown on the business#show page
  # GET /teams or /teams.json
  #def index
  #  @teams = Team.all
  #end

  # GET /teams/1 or /teams/1.json
  def show
    @teammates  = @team.users
    @schemas    = @team.schemas
    @activities = current_user.business.activity_log.for_team(team: @team).limit(8).reverse
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params.merge(business_id: current_user.business.id))

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "Team was successfully updated." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.where(id: params[:id], business_id: current_user.business.id).first
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name)
  end
end
