require "rails_helper"

RSpec.describe Favorite, type: :model do
  context "validations" do
    let(:user) { create(:user) }
    let(:schema) { create(:schema, :with_format, :with_team) }

    it "should validate the schema being favored is accessible to the user" do
      fav = described_class.new(user:, schema:)

      expect(fav.valid?).to be false
    end
  end
end
