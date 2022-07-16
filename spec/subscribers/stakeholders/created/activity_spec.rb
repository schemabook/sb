require "rails_helper"

RSpec.describe Subscribers::Stakeholders::Created::Activity do
  subject { described_class.new }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).to eq(Events::Stakeholders::Created::EVENT_NAME)
  end

  it "subscribes when instantiated" do
    expect_any_instance_of(described_class).to receive(:subscribe)

    described_class.new
  end

  describe "#process" do
    let(:format)  { create(:format, file_type: :json) }
    let(:json)    { '{"foo": {"bar": 1}}' }
    let(:user)    { create(:user) }
    let(:schema)  { create(:schema, :with_format_and_body, team: user.team) }
    let(:stakeholder) { create(:stakeholder, user_id: user.id, schema_id: schema.id) }

    it "persists an Activity object" do
      payload    = Events::Services::Created.new(record: stakeholder).payload
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
