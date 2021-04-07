require 'rails_helper'

RSpec.feature "Dashboards", :type => :feature do
  let!(:business) { create(:business) }
  let!(:user)     { create(:user, business: business) }

  scenario "User sees their info" do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button "Log in"

    expect(page).to have_text(user.email)
    expect(page).to have_text(business.name)
  end
end
