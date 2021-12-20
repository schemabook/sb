require "rails_helper"

RSpec.describe Subscribers::Businesses::Created::ActivityLog do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Businesses::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:business) { create(:business) }
    let(:user)     { create(:user) }

    it "persists an ActivityLog object" do
      payload    = Events::Businesses::Created.new(business: business, user: user).payload
      event_type = "foo"
      event      = ActiveSupport::Notifications::Event.new(
        event_type,
        Time.zone.now - 1.second,
        Time.zone.now,
        123,
        payload
      )

      expect {
        subject.process(event: event)
      }.to change(Activity, :count)
    end
  end
end

