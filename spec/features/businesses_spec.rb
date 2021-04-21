require 'rails_helper'

RSpec.describe "Businesses", type: :feature do
  let(:user)     { create(:user_with_business) }
  let(:business) { user.business }

  before do
    sign_in user
  end

  it "User sees business info" do
    visit business_path(business)

    expect(page).to have_text(business.name)
    expect(page).to have_link("edit", href: edit_business_path(business))
    expect(page).to have_text("Created by: #{user.email}")
    expect(page).to have_text("Created on: #{I18n.l(business.created_at, format: :sample)}")
    expect(page).to have_text("Stakeholders")

    within("ul#stakeholders") do
      expect(page).to have_text(user.email)
    end
  end
end
