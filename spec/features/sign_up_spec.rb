require 'rails_helper'

RSpec.feature "Sign Up", :type => :feature do
  scenario "User registers" do
    visit new_user_registration_path

    fill_in 'user_email', with: 'admin@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'

    click_button "Get started"

    expect(page).to have_text("Welcome! You have signed up successfully.")
  end

  scenario "User is already registered" do
    visit new_user_registration_path

    click_button "Sign in"

    expect(page).to have_text("Sign in to your account")
  end
end
