require 'rails_helper'

RSpec.describe CsvFormatter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :csv) }
  let(:csv)      { build(:csv).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }

  subject { described_class.new(schema:, version:) }

  before do
    version.body = csv
  end

  describe "#to_json" do
    it "returns the body in json format" do
      expect(subject.to_json).to eq("[[\"foo\",\"bar\",\"baz\"]]")
    end

    context "with headers" do
      let(:csv) { build(:csv, :with_headers).to_s }

      it "returns the headers in json format" do
        expect(subject.to_json).to eq("[[\"foo\",\"bar\",\"baz\"]]")
      end
    end

    context "with a non-comma delimiter" do
      let(:csv) { build(:csv, :with_delimiter).to_s }

      it "returns the body in json format" do
        expect(subject.to_json).to eq("[[\"foo\",\"bar\",\"baz\"]]")
      end
    end
  end

  describe "#to_csv" do
    it "returns the body in csv format" do
      csv = subject.to_csv

      expect(csv).to eq(version.body)
    end
  end

  describe "#to_avro" do
    let(:avro) do
      '{"type_sym":"record","logical_type":null,"type_adapter":null,"name":"schema","namespace":null,"doc":null,"aliases":null,"fullname":"schema","fields":[{"type":{"type_sym":"string","logical_type":null,"type_adapter":null},"name":"foo","default":"no_default","order":null,"doc":null,"aliases":null,"type_adapter":null},{"type":{"type_sym":"string","logical_type":null,"type_adapter":null},"name":"bar","default":"no_default","order":null,"doc":null,"aliases":null,"type_adapter":null},{"type":{"type_sym":"string","logical_type":null,"type_adapter":null},"name":"baz","default":"no_default","order":null,"doc":null,"aliases":null,"type_adapter":null}]}'
    end

    it "returns the body in avro format" do
      expect(subject.to_avro).to eq(avro)
    end

    context "with headers" do
      let(:csv) { build(:csv, :with_headers).to_s }

      it "returns the headers in avro format" do
        expect(subject.to_avro).to eq(avro)
      end
    end

    context "with a non-comma delimiter" do
      let(:csv) { build(:csv, :with_delimiter).to_s }

      it "returns the body in avro format" do
        expect(subject.to_avro).to eq(avro)
      end
    end
  end
end
