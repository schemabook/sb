require 'rails_helper'

RSpec.describe "Dashboards", type: :feature do
  let!(:user) { create(:user) }

  it "User sees their info" do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button "Log in"

    expect(page).to have_text(user.email)
  end

  it "User sees standard options" do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button "Log in"

    expect(page).to have_text('Account Settings')
    expect(page).to have_text('Log out')
  end
end
