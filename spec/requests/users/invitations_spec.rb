require 'rails_helper'

RSpec.describe "Invitations", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST users/invitation" do
    # NOTE: the accept_invitation_url is throwing an exception in test only, works in production
    it "should publish an event" do
      expect_any_instance_of(Events::Invitations::Created).to receive(:publish)

      post '/users/invitation/', params: { user: { email: "test@example.com", business_id: user.business.id, team_id: user.team.id } }
    end
  end
end

