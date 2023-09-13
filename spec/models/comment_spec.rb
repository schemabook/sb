require "rails_helper"

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :version }

  it { should validate_presence_of :body }

  context "validate" do
    let(:user) { create(:user) }
    let(:version) { create(:version, :with_schema) } # creates a different comany

    it "prevents commenting on resources owned by another company" do
      expect {
        create(:comment, user:, version:)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
