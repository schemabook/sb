require 'rails_helper'

RSpec.describe PayloadValidator do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }

  subject { described_class.new(schema:, payload:) }

  describe "#valid?" do
    context "with an avro schema" do
      let(:format)   { create(:format, file_type: :avro) }
      let(:avro)     { build(:avro).to_s }
      let(:schema)   { create(:schema, name: "foo", team:, format:) }
      let(:version)  { create(:version, schema:) }
      let(:payload)  do
        {
          first_name: "Steve",
          last_name: "Jobs",
          age: 68
        }
      end

      before do
        version.body = avro
      end

      it "should delegate to the Avro payload validator" do
        expect_any_instance_of(AvroPayloadValidator).to receive(:valid?)

        subject.valid?
      end
    end

    context "with a json schema" do
      let(:format)   { create(:format, file_type: :json) }
      let(:json)     { build(:json).to_s }
      let(:schema)   { create(:schema, name: "foo", team:, format:) }
      let(:version)  { create(:version, schema:) }
      let(:payload)  do
        {
          title: "Moriarty"
        }
      end

      before do
        version.body = json
      end

      it "should delegate to the JSON payload validator" do
        expect_any_instance_of(JsonPayloadValidator).to receive(:valid?)

        subject.valid?
      end
    end

    context "with a csv schema" do
      let(:format)   { create(:format, file_type: :csv) }
      let(:csv)      { build(:csv).to_s }
      let(:schema)   { create(:schema, name: "foo", team:, format:) }
      let(:version)  { create(:version, schema:) }
      let(:payload)  { "foo,bar" }

      before do
        version.body = csv
      end

      it "should delegate to the Csv payload validator" do
        expect_any_instance_of(CsvPayloadValidator).to receive(:valid?)

        subject.valid?
      end
    end
  end
end
