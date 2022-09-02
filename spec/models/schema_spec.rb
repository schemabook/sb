require 'rails_helper'

RSpec.describe Schema, type: :model do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"foo": {"bar": 1}}' }

  subject { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

  it { should belong_to :team }
  it { should belong_to(:service).optional }

  it { should have_many :stakeholders }
  it { should have_many :comments }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:service_id) }

  describe "#body" do
    it "converts string to file and attaches" do
      expect(subject.raw_body.blob.download).to eq(json)
      expect(subject.raw_body.filename.to_s).to eq("foo.json")
    end
  end

  context "private" do
    describe "#body_format" do
      context "with valid body content" do
        it "returns true" do
          expect(subject.send(:body_format)).to be(true)
        end
      end

      context "with invalid body content" do
        it "returns false" do
          subject.body = "{"

          expect(subject.send(:body_format)).to be(false)
          expect(subject.errors.messages[:body].first).to match(/is not valid JSON/)
        end
      end
    end
  end
end
