require "rails_helper"

class TestEvent
  include Events::Event

  EVENT_NAME = "tested.event".freeze

  def payload
    {
      some_attribute: 123
    }
  end

  def schema
    Avro::Builder.build do
      namespace EVENT_NAME

      record :some_object do
        required :some_attribute, :int
      end
    end
  end
end

class EmptyEvent
  include Events::Event
end

RSpec.describe Events::Event do
  subject { TestEvent.new }

  describe "#payload" do
    context "without a payload defined" do
      subject { EmptyEvent.new }

      it "returns a hash by default" do
        expect(subject.payload).to eq({})
      end
    end

    context "with a payload defined" do
      subject { TestEvent.new }

      it "returns the defined payload" do
        expect(subject.payload).not_to eq({})
      end
    end
  end

  describe "#publish" do
    it "validates the payload before broadcasting" do
      allow(subject).to receive(:valid_payload?)

      expect {
        subject.publish
      }.to raise_error(InvalidEventPayloadError)
    end

    context "with a valid payload" do
      before do
        allow(subject).to receive(:valid_payload?).and_return(true)
      end

      it "calls ActiveSupport::Notifications.instrument with the event name and payload" do
        allow(ActiveSupport::Notifications).to receive(:instrument).with(subject.class::EVENT_NAME, subject.payload)

        subject.publish
      end
    end

    context "without an event name defined" do
      subject { EmptyEvent.new }

      before do
        allow(subject).to receive(:valid_payload?).and_return(true)
      end

      it "raises an exception" do
        expect {
          subject.publish
        }.to raise_error(NameError)
      end
    end

    context "with an invalid payload" do
      before do
        allow(subject).to receive(:valid_payload?).and_return(false)
      end

      it "raises an error" do
        expect {
          subject.publish
        }.to raise_error(InvalidEventPayloadError)
      end
    end
  end

  describe "#valid_payload?" do
    context "with a schema defined" do
      context "with a valid payload" do
        it "returns true" do
          expect(subject.valid_payload?).to be(true)
        end
      end

      context "without a valid payload" do
        before do
          allow(subject).to receive(:payload).and_return({})
        end

        it "returns false" do
          expect(subject.valid_payload?).to be(false)
        end
      end
    end

    context "without a schema defined" do
      before do
        allow(subject).to receive(:schema).and_return(nil)
      end

      it "raises an exception" do
        expect {
          subject.valid_payload?
        }.to raise_error(MultiJson::ParseError)
      end
    end
  end

  describe "#encoded_schema" do
    it "returns the schema serialized as RecordSchema used for validation" do
      expect(subject.encoded_schema.class).to eq(Avro::Schema::RecordSchema)
    end
  end
end
