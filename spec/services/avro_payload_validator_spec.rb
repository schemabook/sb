require 'rails_helper'

RSpec.describe AvroPayloadValidator do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :avro) }
  let(:avro)     { build(:avro).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }
  let(:payload)  do
    {
      first_name: "Steve",
      last_name: "Jobs",
      age: 68
    }.to_s
  end

  subject { described_class.new(schema: JSON.parse(schema.versions.last.body.to_json), payload:) }

  before do
    version.body = avro
  end

  describe "#valid?" do
    context "with a valid payload" do
      it "returns true" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "with an invalid payload" do
      let(:payload) { "{}" }

      it "returns false" do
        expect(subject.valid?).to eq(false)
      end
    end
  end
end
