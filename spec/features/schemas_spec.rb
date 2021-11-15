require 'rails_helper'

RSpec.describe "Schemas", type: :feature do
  let(:user)    { create(:user, :admin) }
  let(:service) { create(:service, team: user.team, created_by: user.id) }

  before do
    sign_in user
  end

  context "when creating a schema" do
    before do
      visit new_schema_path
    end

    it "sees info" do
      expect(page).to have_text("Schema Information")
    end

    it "requires a name" do
      expect(page).to have_field(:schema_name)
    end

    it "requires a file_type" do
      expect(page).to have_field(:schema_file_type)
    end

    it "can associate a service" do
      expect(page).to have_field(:schema_service_id)
    end
  end

  context "when viewing a schema" do
    let!(:format) { create(:format) }
    let!(:schema) { create(:schema, format: format, team: user.team, service_id: service.id, body: '[1]') }

    before do
      visit schema_path(schema)
    end

    it "shows the schema name" do
      expect(page).to have_text(schema.name)
    end
  end
end
