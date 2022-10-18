require "rails_helper"

RSpec.describe Subscribers::Services::Created::EmailTeammates do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Services::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:user)    { create(:user) }
    let(:service) { create(:service, team: user.team, name: "foo", created_by: user.id) }
    let!(:teammate) { create(:user, team: user.team, email: 'admin2@example.com') }

    it "persists an Activity object" do
      payload    = Events::Services::Created.new(record: service, user:).payload
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

