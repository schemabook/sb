require 'rails_helper'

RSpec.describe "Schemas", type: :feature do
  let(:user) { create(:user, :admin) }

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

    it "can add a name" do
      expect(page).to have_text("Name")
    end

    xit "can add a type" do
      expect(page).to have_text("select")
    end
  end

  context "when viewing a schema" do
    let!(:schema) { create(:schema, team: user.team) }

    before do
      visit schema_path(schema)
    end

    it "shows the schema name" do
      expect(page).to have_text(schema.name)
    end
  end
end
