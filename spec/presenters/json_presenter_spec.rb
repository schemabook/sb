require 'rails_helper'

RSpec.describe JsonPresenter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { build(:json).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:, body: json) }

  subject { described_class.new(schema, version) }

  describe "#content" do
    context "when original format is json" do
      it "returns the json pretty formatted" do
        expected = JSON.pretty_generate(JSON.parse(json))

        expect(subject.content).to eq(expected)
      end
    end

    context "when original format is not json" do
      context "when convertible to json" do
        let(:format)   { create(:format, file_type: :json) }
        let(:avro)     { build(:avro).to_s }
        let(:schema)   { create(:schema, name: "foo", team:, format:) }
        let(:version)  { create(:version, schema:, body: avro) }

        it "returns the body as pretty printed JSON string" do
          allow(JSON).to receive(:pretty_generate).and_return(json)

          expect(subject.content).to eq(json)
        end
      end

      context "when not convertible to json" do
        it "returns an error messasge string" do
          allow_any_instance_of(SchemaFormatter).to receive(:as_json).and_raise(JsonFormatter::ConversionError)

          expect(subject.content).to match(/can not be converted to JSON/)
        end
      end
    end
  end

  describe "#content_length" do
    it "returns the line counts of the content when pretty printed" do
      expect(subject.content_length).to eq(5)
    end
  end
end
