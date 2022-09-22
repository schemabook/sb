require 'rails_helper'

RSpec.describe "StakeholdersController", type: :request do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }

  before do
    sign_in user
  end

  describe "POST create" do
    subject { post stakeholders_path, params: { stakeholder: { user_id: user.id, schema_id: nil } } }

    it "should assign stakeholder" do
      subject

      expect(assigns(:stakeholder).class).to eq(Stakeholder)
    end

    context "if stakeholder can not be saved" do
      it "sets a flash alert" do
        subject

        expect(flash[:alert]).to match(/Could not be added as a stakeholder/)
      end

      it "renders an internal_server_error" do
        subject

        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context "if stakeholder can be saved" do
      subject { post stakeholders_path, params: { stakeholder: { user_id: user.id, schema_id: create(:schema, :with_team, :with_format).id } } }

      it "sets a flash message" do
        subject

        expect(flash[:message]).to match(/You have been added as a stakeholder/)
      end

      it "renders an ok" do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

  end
end
