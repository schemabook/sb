require 'rails_helper'

RSpec.describe JsonFormatter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { build(:json).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }

  subject { described_class.new(schema:, version:) }

  before do
    version.body = json
  end

  describe "#to_json" do
    it "returns the body in json format" do
      expect(subject.to_json).to eq(json)
    end
  end

  describe "#to_avro" do
    context "when the JSON can be converted" do
      let(:json) { build(:json, :with_types).to_s }

      it "returns the body in avro format" do
        avro = subject.to_avro

        expect(JSON.parse(avro).keys).to include("fields")
      end
    end

    context "when the JSON can't be converted" do
      context "when a type is missing" do
        it "raises an exception" do
          expect {
            subject.to_avro
          }.to raise_error(JsonFormatter::ConversionError, /No "type" property/)
        end
      end

      context "when an attribute type is not known" do
        # type should be string not String
        let(:json) { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "String" }]}' }

        it "raises an exception around the schema type now known" do
          expect {
            subject.to_avro
          }.to raise_error(JsonFormatter::ConversionError, /"String" is not a schema we know about/)
        end
      end
    end
  end

  describe "#to_csv" do
    context "when the JSON can be converted with a single field" do
      let(:json) { '{"type": "record", "name": "book", "fields": [{ "name": "title", "type": "string" }]}' }

      it "returns the body in csv format" do
        csv = subject.to_csv

        expect(csv).to eq("name,type\ntitle,string\n")
      end
    end

    context "when the JSON can be converted with mulitple fields" do
      let(:json) { '{"type": "record", "name": "book", "fields": [{ "name": "title", "type": "string" }, { "name": "author", "type": "string" }]}' }

      it "returns the body in csv format" do
        csv = subject.to_csv

        expect(csv).to eq("name,type\ntitle,string\nauthor,string\n")
      end
    end

    context "when the JSON can be converted with mulitple fields with different types" do
      let(:json) do
        '{
            "type": "record",
            "name": "book",
            "fields": [
              {
                "name": "title",
                "type": "string"
              },
              {
                "name": "author",
                "type": "string",
                "required": "boolean"
              },
              {
                "name": "pages",
                "type": "integer"
              }
            ]
        }'
      end

      it "returns the body in csv format" do
        csv = subject.to_csv

        expect(csv).to eq("name,type,required\ntitle,string,\"\"\nauthor,string,boolean\npages,integer,\"\"\n")
      end
    end
  end
end
