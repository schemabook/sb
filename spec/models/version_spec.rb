require 'rails_helper'

RSpec.describe Version, type: :model do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"foo": {"bar": 1}}' }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }

  subject { described_class.create(schema:) }

  it { should have_many :comments }
  it { should belong_to :schema }

  it { should delegate_method(:name).to(:schema).allow_nil }
  it { should delegate_method(:format).to(:schema).allow_nil }

  describe "#body" do
    before do
      subject.body = json
    end

    it "converts string to file and attaches" do
      expect(subject.raw_body.blob.download).to eq(json)
      expect(subject.raw_body.filename.to_s).to eq("foo+v1.json")
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
