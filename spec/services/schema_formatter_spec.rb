require 'rails_helper'

RSpec.describe SchemaFormatter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }

  subject { described_class.new(schema:, version:) }

  context "when format is json" do
    let(:format) { create(:format, file_type: :json) }
    let(:json)   { build(:json).to_s }

    describe "#as_json" do
      it "calls the appropriate formatter class" do
        version.body = json

        expect_any_instance_of(JsonFormatter).to receive(:to_json)

        subject.as_json
      end
    end
  end

  context "when format is csv" do
    let(:format) { create(:format, file_type: :csv) }
    let(:csv)    { build(:csv).to_s }

    describe "#as_csv" do
      it "calls the appropriate formatter class" do
        version.body = csv

        expect_any_instance_of(CsvFormatter).to receive(:to_csv)

        subject.as_csv
      end
    end
  end

  context "when format is avro" do
    let(:format) { create(:format, file_type: :avro) }
    let(:avro)   { build(:avro).to_s }

    describe "#as_avro" do
      it "calls the appropriate formatter class" do
        version.body = avro

        expect_any_instance_of(AvroFormatter).to receive(:to_avro)

        subject.as_avro
      end
    end
  end
end
