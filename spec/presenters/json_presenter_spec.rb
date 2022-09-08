require 'rails_helper'

RSpec.describe JsonPresenter do
  let(:business) { create(:business) }
  let(:team)     { create(:team, business:) }
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"foo": {"bar": 1}}' }
  let(:schema)   { create(:schema, name: "foo", file_type: "json", body: json, team:, format:) }

  subject { described_class.new(schema) }

  describe "#content" do
    context "when original format is json" do
      it "returns the json pretty formatted" do
        expected = JSON.pretty_generate(JSON.parse(json))

        expect(subject.content).to eq(expected)
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
      expect(subject.content_length).to eq(5)
    end
  end
end
