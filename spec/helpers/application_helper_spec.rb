require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#avatar" do
    context "with no attachment" do
      let(:user) { create(:user) }

      it "uses gravatar" do
        result = avatar(user, size: 100)
        expect(result).to match(/gravatar/)
      end
    end

    context "with attachment" do
      let(:user) { create(:user, :with_avatar) }

      it "uses the attachment" do
        result = avatar(user, size: 100)
        expect(result).to match(/active_storage/)
      end
    end
  end
end
