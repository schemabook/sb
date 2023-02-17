require 'rails_helper'

RSpec.describe AvroPresenter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :avro) }
  let(:avro)     { build(:avro).to_s }
  let(:schema)   { create(:schema, name: "foo", team:, format:) }
  let(:version)  { create(:version, schema:, body: avro) }

  subject { described_class.new(schema, version) }

  describe "#content" do
    context "when original format is avro" do
      it "returns the avro version pretty printed" do
        avro     = SchemaFormatter.new(schema:, version:).as_avro
        expected = JSON.pretty_generate(JSON.parse(avro))

        expect(subject.content).to eq(expected)
      end
    end

    context "when original format is not avro" do
      it "returns the body as an Avro JSON string" do
        expect_any_instance_of(SchemaFormatter).to receive(:as_avro).and_return("{}")

        expect(subject.content).to eq("{\n}")
      end
    end

    context "when original format can not be converted to avro" do
      it "returns an error messasge string" do
        expect_any_instance_of(SchemaFormatter).to receive(:as_avro).and_raise(AvroFormatter::ConversionError)

        expect(subject.content).to match(/can not be converted to Avro/)
      end
    end
  end

  describe "#content_length" do
    it "returns the line counts of the content" do
      expect(subject.content_length).to eq(18)
    end
  end
end
