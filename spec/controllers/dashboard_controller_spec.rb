require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  let(:business)  { create(:business) }
  let!(:user)     { create(:user, business: business) }
  let!(:log)      { create(:activity_log, business: business) }
  let!(:activity) { create(:activity, activity_log: log, user: user) }

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
  end
end
