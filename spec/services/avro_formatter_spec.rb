require 'rails_helper'

RSpec.describe AvroFormatter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :avro) }
  let(:avro)     { build(:avro).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:) }

  subject { described_class.new(schema:, version:) }

  before do
    version.body = avro
  end

  describe "#to_avro" do
    it "returns the body in avro format" do
      expect(subject.to_avro).to eq(avro)
    end
  end

  describe "#to_json" do
    it "returns the body in JSON format" do
      expect(subject.to_json).to eq(Avro::Schema.parse(avro).to_json)
    end
  end

  describe "#to_csv" do
    context "when avro is a shallow structure" do
      it "returns the body in csv format" do
        expect(subject.to_csv).to eq("name,type\nfirst_name,string\nlast_name,string\nage,int\n")
      end
    end

    context "when avro is a deeply nested structure" do
      let(:avro) { build(:avro, :nested).to_s }

      it "raise an exception" do
        expect {
          subject.to_csv
        }.to raise_error AvroFormatter::ConversionError
      end
    end
  end
end
