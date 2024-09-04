require "rails_helper"

RSpec.describe Subscribers::Webhooks::Created::Activity do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Webhooks::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:format) { create(:format, file_type: :json) }
    let(:user)   { create(:user) }
    let(:schema) { create(:schema, :with_team, name: "foo", format:) }
    let(:webhook) { create(:webhook, schema:, user:, url: "https://example.com") }

    it "persists an Activity object" do
      payload    = Events::Webhooks::Created.new(record: webhook, user:).payload
      event_type = "foo"
      event      = ActiveSupport::Notifications::Event.new(
        event_type,
        1.second.ago,
        Time.zone.now,
        123,
        payload
      )

      expect {
        subject.process(event:)
      }.to change(Activity, :count)
    end
  end
end

