require 'rails_helper'

RSpec.describe CsvValidator do
  describe "self.validate" do
    context "with valid csv" do
      let(:body) { 'this,is,valid' }

      it "returns true" do
        expect(described_class.validate(body)).to be(true)
      end
    end

    context "with no input" do
      let(:body) { nil }

      it "returns false" do
        expect(described_class.validate(body)).to be(false)
      end
    end

    context "with malformed input (mismatched quote)" do
      let(:body) { "foo,0\nbar,1\nbaz,2\n'\"'" }

      it "returns false" do
        expect(described_class.validate(body)).to be(false)
      end
    end
  end
end
