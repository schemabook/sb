require 'rails_helper'

RSpec.describe JsonPayloadValidator do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { build(:json, :with_types).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }
  let(:payload) { '{"title":"harry potter"}' }

  subject { described_class.new(schema: JSON.parse(schema.versions.last.body.to_json), payload:) }

  before do
    version.body = json
  end

  describe "#valid?" do
    context "with a valid payload" do
      it "returns true" do
        expect(subject.valid?).to be true
      end
    end

    context "with an invalid payload" do
      let(:payload) { "foo" }

      it "returns false" do
        expect(subject.valid?).to be false
      end
    end
  end
end
