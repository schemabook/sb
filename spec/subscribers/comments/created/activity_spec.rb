require "rails_helper"

RSpec.describe Subscribers::Comments::Created::Activity do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Comments::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:comment) { create(:comment, :with_user_and_version) }
    let!(:log) { create(:activity_log, business: comment.user.business) }

    it "persists an ActivityLog object" do
      payload    = Events::Comments::Created.new(record: comment, user: comment.user).payload
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
