require "rails_helper"

RSpec.describe Subscribers::Businesses::Created::WelcomeEmail do
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

    it "delivers a welcome email" do
      payload    = Events::Businesses::Created.new(business:, user:).payload
      event_type = "foo"
      event      = ActiveSupport::Notifications::Event.new(
        event_type,
        1.second.ago,
        Time.zone.now,
        123,
        payload
      )

      expect do
        subject.process(event:)
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
