require "rails_helper"

RSpec.describe Subscribers::Schemas::Created::Activity do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Schemas::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:format) { create(:format, file_type: :json) }
    let(:json)   { '{"foo": {"bar": 1}}' }
    let(:user)   { create(:user) }
    let(:schema) { create(:schema, :with_team, name: "foo", file_type: "json", body: json, format: format) }

    it "persists an Activity object" do
      payload    = Events::Schemas::Created.new(record: schema, user: user).payload
      event_type = "foo"
      event      = ActiveSupport::Notifications::Event.new(
        event_type,
        Time.zone.now - 1.second,
        Time.zone.now,
        123,
        payload
      )

      expect {
        @activity = subject.process(event: event)
      }.to change(Activity, :count)
    end
  end
end

