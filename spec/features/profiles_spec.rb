require 'rails_helper'

RSpec.describe "Profiles", type: :feature do
  let(:user) { create(:user, :admin) }

  before do
    sign_in user
  end

  context "when current user" do
    before do
      visit user_profile_path(user)
    end

    it "sees info" do
      expect(page).to have_text(user.email)
    end

    it "sees team as link" do
      within("ul#team") do
        expect(page).to have_link(user.team.name, href: team_path(user.team))
      end
    end

    it "sees activities" do
      expect(page).to have_text("Activity")
    end
  end

  context "when an admin" do
    let!(:new_team) { create(:team, business: user.business) }

    before do
      visit user_profile_path(user)
    end

    it "sees a link to edit team" do
      expect(page).to have_link("Edit Team", href: edit_user_profile_path(user))
    end

    it "can edit the team" do
      visit edit_user_profile_path(user)

      select new_team.name, from: :user_team_id
      find('button', text: 'Save').click

      user.reload
      expect(user.team.name).to eq(new_team.name)
    end
  end
end
