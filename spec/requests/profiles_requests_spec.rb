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

  describe "PATCH update" do
    context "when updating the associated team" do
      let(:new_team) { create(:team, business: user.business) }
      let(:params)   { { id: user.id, user: { team_id: new_team.id } } }

      before do
        sign_in user
      end

      it "assign the user to the new team" do
        patch patch_user_profile_path(params)

        user.reload
        expect(user.team_id).to eq(new_team.id)
      end

      it "should set a flash notice" do
        patch patch_user_profile_path(params)

        expect(flash[:notice]).to match(/User profile has been updated/)
      end

      it "should publish an event" do
        expect_any_instance_of(Events::Users::Updated).to receive(:publish)

        patch patch_user_profile_path(params)
      end

      context "with an invalid team id" do
        let(:params)   { { id: user.id, user: { team_id: 999999999 } } }

        it "should" do
          patch patch_user_profile_path(params)

          expect(flash[:warning]).to match(/User profile has not been updated/)
        end
      end
    end
  end
end
