require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }
  let!(:activity) { create(:activity, activity_log: business.activity_log, user:) }
  let!(:team)     { create(:team, business:) }
  let!(:schema)   { create(:schema, :with_format_and_body, team:) }

  before do
    sign_in user
  end

  describe "GET index" do
    it "renders the index template" do
      get :index

      expect(response).to render_template("index")
    end

    it "assigns @activities" do
      get :index

      expect(assigns(:activities)).to eq([activity])
    end

    it "assigns @schemas" do
      get :index

      expect(assigns(:schemas)).to eq([schema])
    end
  end
end
