require 'rails_helper'

RSpec.describe "StakeholdersController", type: :request do
  let!(:business) { create(:business, :with_activity_log) }
  let!(:user)     { create(:user, business:) }
  let!(:schema)   { create(:schema, :with_format, team: user.team) }

  before do
    sign_in user
  end

  describe "POST create" do
    subject { post stakeholders_path, params: { stakeholder: { user_id: user.id, schema_id: schema.id } } }

    it "should assign stakeholder" do
      subject

      expect(assigns(:stakeholder).class).to eq(Stakeholder)
    end

    context "if stakeholder can not be saved" do
      let(:schema) { create(:schema, :with_format, :with_team) }

      it "raise an ActiveRecord error" do
        expect {
          subject
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "if stakeholder can be saved" do
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
