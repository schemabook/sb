require 'rails_helper'
require_relative "../../app/controllers/validations_controller"

RSpec.describe ValidationsController, type: :request do
  describe "#create" do
    let(:business) { create(:business) }
    let(:team)     { create(:team, business:) }
    let(:format)   { create(:format, file_type: :json) }
    let(:json)     { build(:json, :with_types).to_s }
    let(:schema)   { create(:schema, name: "foo", team:, format:) }
    let!(:version) { create(:version, schema:) }
    let(:payload)  { '{"title":"harry potter"}' }

    before do
      version.body = json
    end

    it "should return a 200" do
      post "/schemas/#{schema.public_id}/validations", params: { payload: }

      expect(response).to have_http_status(:ok)
    end

    context "with an invalid payload" do
      let(:payload) do
        {
          foo: "not a title field"
        }
      end

      it "should return a 422" do
        post "/schemas/#{schema.public_id}/validations", params: { payload: }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
