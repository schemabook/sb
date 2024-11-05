require 'rails_helper'

RSpec.describe Webhook, type: :model do
  let(:user) { create(:user, email: "webhook@example.com") }
  let(:team) { user.team }
  let(:format) { create(:format, file_type: :json) }
  let(:schema) { create(:schema, name: "foo", team:, format:) }
  let(:json) { '{"foo": {"bar": 1}}' }
  let(:version) { create(:version, schema:) }

  before do
    version.body = json
  end

  subject { create(:webhook, user:, schema:) }

  it { should belong_to :schema }
  it { should belong_to :user }
  it { should validate_presence_of :url }
  it { should validate_uniqueness_of(:url).scoped_to(:schema_id) }

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

  describe "#payload" do
    it "includes the schemabook url for the associated schema" do
      expect(subject.payload[:url]).to eq(subject.schema.url)
    end

    it "includes the latest version body of the schema" do
      version_definition = JsonPresenter.new(subject.schema, subject.schema.versions.last).content

      expect(subject.payload[:definition]).to match(version_definition)
    end
  end
end
