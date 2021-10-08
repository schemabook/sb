require 'rails_helper'

RSpec.describe "Businesses", type: :feature do
  let(:user)     { create(:user, :admin) }
  let(:business) { user.business }

  before do
    sign_in user
  end

  context "when non-admin" do
    before do
      user.team = create(:team, business: business)
    end

    it "sees business info" do
      visit business_path(business)

      expect(page).to have_text(business.name)
      expect(page).to have_text("Created by: #{user.email}")
      expect(page).to have_text("Created on: #{I18n.l(business.created_at, format: :sample)}")
      expect(page).to have_text("Teammates")
      expect(page).to have_link("Invite Teammate", href: new_user_invitation_path)

      within("ul#stakeholders") do
        expect(page).to have_text(user.email)
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
