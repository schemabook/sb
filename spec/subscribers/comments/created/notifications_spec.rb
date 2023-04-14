require "rails_helper"

RSpec.describe Subscribers::Comments::Created::Notifications do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Comments::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:comment) { create(:comment, :with_user, :with_version) }
    let(:user)    { create(:user) }
    let!(:teammate) { create(:user, team: comment.version.schema.team, email: 'admin2@example.com') }

    it "mails the team" do
      payload    = Events::Comments::Created.new(record: comment, user: comment.user).payload
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
