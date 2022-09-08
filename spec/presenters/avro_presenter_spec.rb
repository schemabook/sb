require 'rails_helper'

RSpec.describe AvroPresenter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "string" }]}' }
  let(:schema)   { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

  subject { described_class.new(schema) }

  describe "#content" do
    context "when original format is json" do
      it "returns the avro version pretty formatted" do
        avro     = SchemaFormatter.new(schema:).as_avro
        expected = JSON.pretty_generate(JSON.parse(avro))

        expect(subject.content).to eq(expected)
      end

      context "when the json can't be converted to avro" do
        let(:json) { '{}' }

        it "returns an error message" do
          expected = "The JSON definition can't be converted to Avro"

          expect(subject.content).to match(expected)
        end
      end
    end

    context "when original format is not json" do
      it "returns the body as JSON" do
        pending("need to implement conversions from other formats in SchemaFormatter")
        raise "this is a temporary failure"
      end
    end
  end

  describe "#content_length" do
    it "returns the line counts of the content" do
      expect(subject.content_length).to eq(22)
    end
  end
end
