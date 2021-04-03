require 'rails_helper'

RSpec.feature "Sign In", :type => :feature do
  let!(:business) { create(:business) }
  let!(:user)     { create(:user, business: business) }

  scenario "User is already registered" do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button "Log in"

    expect(page).to have_text("Signed in successfully")
  end

  scenario "User is not yet registered" do
    visit new_user_session_path

    click_button "Get started"

    expect(page).to have_text("Create your account")
  end
end
