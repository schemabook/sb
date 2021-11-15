require 'rails_helper'

RSpec.describe Service, type: :model do
  it { should belong_to :team }
  it { should validate_presence_of :name }
  it { should validate_presence_of :created_by }
  it { should validate_uniqueness_of(:name).scoped_to(:team_id) }

  describe "#creator" do
    let(:business) { create(:business) }
    let(:team)     { create(:team, business: business) }
    let(:user)     { create(:user, team: team) }
    let(:service)  { create(:service, team: team, created_by: user.id) }

    it "returns the user that created the service" do
      expect(service.creator).to eq(user)
    end
  end
end
