require 'rails_helper'

RSpec.describe CsvPresenter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :csv) }
  let(:csv)      { build(:csv).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:, body: csv) }

  subject { described_class.new(schema, version) }

  describe "#content" do
    context "when original format is csv" do
      it "returns the csv body" do
        expect(subject.content).to eq(csv)
      end
    end

    context "when original format is not csv" do
      context "when convertible to csv" do
        let(:format)   { create(:format, file_type: :avro) }
        let(:avro)     { build(:avro).to_s }
        let(:schema)   { create(:schema, name: "foo", team:, format:) }
        let(:version)  { create(:version, schema:, body: avro) }

        it "returns the body as a CSV string" do
          expect(subject.content).to eq("name,type\nfirst_name,string\nlast_name,string\nage,int\n")
        end
      end

      context "when not convertible to csv" do
        it "returns an error messasge string" do
          expect_any_instance_of(SchemaFormatter).to receive(:as_csv).and_raise(CsvFormatter::ConversionError)

          expect(subject.content).to match(/can not be converted to CSV/)
        end
      end
    end
  end

  describe "#content_length" do
    it "returns the line counts of the content" do
      expect(subject.content_length).to eq(1)
    end
  end
end
