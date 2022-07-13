require "rails_helper"

RSpec.describe Subscribers::Invitations::Created::ActivityLog do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Invitations::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:business) { create(:business) }
    let(:user)     { create(:user, business:) }
    let(:teammate) { create(:user, email: "teammate@example.com") }

    it "persists an ActivityLog object" do
      payload    = Events::Invitations::Created.new(teammate:, user:).payload
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

