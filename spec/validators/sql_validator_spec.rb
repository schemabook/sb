require 'rails_helper'

RSpec.describe SqlValidator do
  describe "self.validate" do
    context "with valid sql" do
      let(:body) { 'select 1' }

      it "returns true" do
        expect(described_class.validate(body)).to be(true)
      end
    end

    context "with invalid sql" do
      let(:body) { 'selct 1' } # select typo

      it "returns false" do
        expect(described_class.validate(body)).to be(false)
      end
    end
  end

  describe "self.errors" do
    context "with valid sql" do
      let(:body) { 'select 1' }

      it "returns no errors" do
        expect(described_class.errors(body)).to be(true)
      end
    end

    context "with invalid sql" do
      let(:body) { 'foo' }

      it "returns errors" do
        expect {
          described_class.errors(body)
        }.to raise_error(StandardError)
      end
    end
  end
end
