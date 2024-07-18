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

      expect(schema1.team.business.schemas).to contain_exactly(schema1, schema2)
    end
  end

  describe "#services" do
    it "returns a collection of Services associated to the teams of the business" do
      user = create(:user)
      service1 = create(:service, :with_team, created_by: user.id)
      service2 = create(:service, team: service1.team, created_by: user.id)

      expect(service1.team.business.services).to contain_exactly(service1, service2)
    end
  end
end
