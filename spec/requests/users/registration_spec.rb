require 'rails_helper'

RSpec.describe "Registration", type: :request do
  describe "GET users/new" do
    subject { get new_user_registration_path }

    it "should render the form" do
      expect(subject).to render_template(:new)
    end
  end

  describe "POST users" do
    let(:user_params) { attributes_for(:user) }
    let(:params)      { { user: user_params.merge(business: "valid-business") } }

    subject { post user_registration_path, params: }

    it "should create a business" do
      expect {
        subject
      }.to change(Business, :count)
    end

    it "should create a team" do
      expect {
        subject
      }.to change(Team, :count)
    end

    it "should create a user" do
      expect {
        subject
      }.to change(User, :count)
    end

    it "associates the business to the user" do
      subject

      user = User.last
      expect(user.business).to eq(Business.last)
    end

    it "associates the team to the user" do
      subject

      user = User.last
      expect(user.team).to eq(Team.last)
    end

    it "should go to the after sign up path upon success" do
      expect(subject).to redirect_to(user_root_path) # which redirects to /dashboards
    end

    context "when a business name is already taken" do
      let!(:business)      { create(:business) }
      let(:invalid_params) { user_params.merge(business: business.name) }

      subject { post user_registration_path, params: { user: invalid_params } }

      it "should re-render the form with errors" do
        expect(subject).to render_template(:new)
      end
    end
  end
end
