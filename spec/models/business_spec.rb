require "rails_helper"

RSpec.describe Business, type: :model do
  subject { described_class.new(name: "example") }

  it { should have_many :users }
  it { should have_many :teams }
  it { should have_one :activity_log }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  describe "#schemas" do
    it "returns a collection of Schemas associated to the teams of the business" do
      schema1 = create(:schema, :with_team, :with_format)
      schema2 = create(:schema, :with_format, team: schema1.team)

      expect(schema1.team.business.schemas).to match_array([schema1, schema2])
    end
  end
end
