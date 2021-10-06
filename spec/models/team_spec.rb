require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { create(:team, business: create(:business)) }

  it { should have_many :users }
  it { should belong_to :business }

  context "validations" do
    it { should validate_presence_of :business_id }

    describe "uniqueness" do
      let(:name)     { "foo" }
      let(:business) { create(:business) }

      it "should prevent teams with the same name in the same business" do
        team_a = create(:team, name: name, business: business)

        expect {
          create(:team, name: team_a.name, business: business)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#admin?" do
    it "returns true if the team name matches the admin team name" do
      team = build(:team, name: Team::ADMIN_TEAM_NAME)

      expect(team.admin?).to eq(true)
    end
  end
end
