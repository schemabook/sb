require "rails_helper"

class TestSubscriber
  include Subscribers::Subscriber
end

RSpec.describe Subscribers::Subscriber do
  subject { TestSubscriber.new }

  describe "#subscribe" do
    context "without an EVENT_NAME defined" do
      it "raises an exception" do
        expect {
          subject.subscribe
        }.to raise_error(NameError)
      end
    end

    context "with an EVENT_NAME defined" do
      let(:value) { "foo" }

      before do
        stub_const("TestSubscriber::EVENT_NAME", value)
      end

      it "calls ActiveSupport::Notifications.subscribe with the EVENT_NAME" do
        expect(ActiveSupport::Notifications).to receive(:subscribe).with(value)

        subject.subscribe
      end
    end
  end

  describe "#process" do
    context "without a process method defined" do
      it "raises an informative error" do
        expect {
          subject.process
        }.to raise_error(NoMethodError, "Your subscriber needs to define a process method")
      end
    end
  end
end
