require 'rails_helper'

RSpec.describe SchemaFormatter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"foo": {"bar": 1}}' }
  let(:schema)   { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

  subject { described_class.new(schema: schema) }

  describe "#as_json" do
    context "when body format is json" do
      it "returns the body in json format" do

      end
    end
  end

  describe "#as_avro" do
    context "when body format is json" do
      before do
        expect(schema.format.json?).to be_truthy
      end

      context "when the JSON can be converted" do
        let(:json)   { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "string" }]}' }
        let(:schema) { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

        it "returns the body in avro format" do
          avro = subject.as_avro

          expect(avro.class).to eq(Avro::Schema::RecordSchema)
          expect(avro.as_json.keys.include?("fields")).to be_truthy
        end
      end

      context "when the JSON can't be converted" do
        context "when a type is missing" do
          let(:json)   { '{"foo": {"bar": 1}}' }
          let(:schema) { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

          it "raises an exception" do
            expect {
              subject.as_avro
            }.to raise_error(SchemaFormatter::ConversionError, /No \"type\" property/)
          end
        end

        context "when an attribute type is not known" do
          # type should be string not String
          let(:json)   { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "String" }]}' }
          let(:schema) { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

          it "raises an exception around the schema type now known" do
            expect {
              subject.as_avro
            }.to raise_error(SchemaFormatter::ConversionError, /\"String\" is not a schema we know about/)
          end
        end
      end
    end
  end

  describe "#as_csv" do
    context "when body format is json" do
      before do
        expect(schema.format.json?).to be_truthy
      end

      context "when the JSON can be converted" do
        let(:json)   { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "string" }]}' }
        let(:schema) { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

        it "returns the body in avro format" do
          csv = subject.as_csv

          expect(csv).to eq("name,type\ntitle,string\n")
        end
      end
    end
  end
end
