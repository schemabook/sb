require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to :business }
  it { should belong_to :team }

  it { should accept_nested_attributes_for :business }

  it { should validate_presence_of :email }
  it { should validate_presence_of :business }
  it { should validate_presence_of :team }

  describe "#admin?" do
    let(:business) { create(:business) }
    let(:team)     { create(:team, name: Team::ADMIN_TEAM_NAME, business: business) }

    subject { create(:user, team: team) }

    it "returns true if the user belongs to the administrators team" do
      expect(subject.admin?).to eq(true)
    end
  end
end
