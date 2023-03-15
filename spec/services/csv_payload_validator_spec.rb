require 'rails_helper'

RSpec.describe CsvPayloadValidator do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :csv) }
  let(:csv)      { build(:csv).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }
  let(:payload)  { "foo,bar,baz" }

  subject { described_class.new(schema: schema.versions.last.body, payload:) }

  before do
    version.body = csv
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
