require 'rails_helper'

RSpec.describe JsonValidator do
  describe "self.validate" do
    context "with valid json" do
      let(:body) { '{"foo": {"bar": 1}}' }

      it "returns true" do
        expect(described_class.validate(body)).to be(true)
      end
    end

    context "with invalid json" do
      let(:body) { 'foo' }

      it "returns false" do
        expect(described_class.validate(body)).to be(false)
      end
    end

  end
end
