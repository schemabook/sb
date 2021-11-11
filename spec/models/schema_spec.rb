require 'rails_helper'

RSpec.describe Schema, type: :model do
  it { should belong_to :team }
  it { should belong_to(:service).optional }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:service_id) }
  it { should validate_presence_of :team_id }

  let(:business) { create(:business) }
  let(:team)     { create(:team, business: business) }
  let(:format)   { create(:format, file_type: :json) }
  let(:value)    { "foo" }

  subject { create(:schema, name: "foo", file_type: "json", body: value, team: team, format: format) }

  describe "#body" do
    it "converts string to file and attaches" do
      subject.body = value

      expect(subject.raw_body.blob.download).to eq(value)
      expect(subject.raw_body.filename.to_s).to eq("foo.json")
    end
  end
end
