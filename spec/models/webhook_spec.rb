require 'rails_helper'

RSpec.describe Webhook, type: :model do
  let(:user) { create(:user, email: "webhook@example.com") }
  let(:team) { user.team }
  let(:format) { create(:format, file_type: :json) }
  let(:json) { '{"foo": {"bar": 1}}' }
  let(:schema) { create(:schema, name: "foo", team:, format:) }

  subject { described_class.new(user:, schema:) }

  it { should belong_to :schema }
  it { should belong_to :user }
  it { should validate_presence_of :url }

  describe "validates urls" do
    it "denies invalid urls" do
      subject.url = "f"

      expect(subject.valid?).to be false
    end

    it "allows valid urls" do
      subject.url = "https://example.com"

      expect(subject.valid?).to be true
    end
  end
end
