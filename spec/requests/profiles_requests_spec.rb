require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let!(:business) { create(:business) }
  let!(:user)     { create(:user, business: business) }

  before do
    sign_in user
  end

  describe "GET show" do
    subject { get user_profile_path(user) }

    it "should render the template" do
      expect(subject).to render_template(:show)
    end
  end

  describe "GET edit" do
    context "when an admin" do
      let(:admin) { create(:user, :admin, business: business, email: "new_admin@example.com") }

      before do
        sign_in admin
      end

      subject { get edit_user_profile_path(user) }

      it "should render the template" do
        expect(subject).to render_template(:edit)
      end
    end

    context "when the current user" do
      before do
        sign_in user
      end

      subject { get edit_user_profile_path(user) }

      it "should render the template" do
        expect(subject).to render_template(:edit)
      end
    end

    context "when a different non-admin user" do
      let(:colleague) { create(:user, business: business, email: "colleague@example.com") }

      before do
        sign_in colleague
      end

      subject { get edit_user_profile_path(user) }

      it "should redirect" do
        expect(subject).to redirect_to(user_profile_path(colleague))
      end
    end
  end
end
