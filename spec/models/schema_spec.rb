require 'rails_helper'

RSpec.describe Schema, type: :model do
  it { should belong_to :team }

  it { should validate_presence_of :name }

  context "with validations" do
    it { should validate_presence_of :team_id }

    describe "uniqueness" do
      let(:name)     { "foo" }
      let(:business) { create(:business) }
      let(:team)     { create(:team, business: business) }

      it "should prevent schemas with the same name in the same business" do
        schema_a = create(:schema, name: name, team: team)

        expect {
          create(:schema, name: schema_a.name, team: team)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
