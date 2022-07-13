require 'rails_helper'

RSpec.describe "Businesses", type: :feature do
  let(:user)     { create(:user, :admin) }
  let(:business) { user.business }

  before do
    sign_in user
  end

  context "when non-admin" do
    before do
      user.team = create(:team, business:)

      visit business_path(business)
    end

    it "sees business info" do
      expect(page).to have_text(business.name)
      expect(page).to have_text("Created by: #{user.email}")
      expect(page).to have_text("Created on: #{I18n.l(business.created_at, format: :sample)}")
    end

    it "sees teams as links" do
      expect(page).to have_text("Teams")

      within("ul#teams") do
        expect(page).to have_link(user.team.name, href: team_path(user.team))
      end
    end

    it "sees teammates as links" do
      expect(page).to have_text("Teammates")
      expect(page).to have_link("Invite Teammate", href: new_user_invitation_path)

      within("ul#stakeholders") do
        expect(page).to have_link(user.email, href: user_profile_path(user))
      end
    end

    it "does not see edit buttons" do
      expect(page).not_to have_link("Edit Info", href: edit_business_path(business))
      expect(page).not_to have_link("Create Team", href: new_team_path)
    end
  end

  it "Admin user can edit business info" do
    visit business_path(business)

    expect(page).to have_text(business.name)
    expect(page).to have_link("Edit Info", href: edit_business_path(business))
  end

  it "Admin user can create teams" do
    visit business_path(business)

    expect(page).to have_text(business.name)
    expect(page).to have_link("Create Team", href: new_team_path)
  end

  it "Admin edits business info" do
    visit edit_business_path(business)

    fill_in :business_name, with: "Nike"
    fill_in :business_street_address, with: "1 Bowerman Drive"
    fill_in :business_city, with: "Beaverton"
    fill_in :business_state, with: "OR"
    fill_in :business_postal, with: "97222"
    select "United States", from: :business_country

    click_on "Save"

    expect(page).to have_text("Nike")
  end
end
