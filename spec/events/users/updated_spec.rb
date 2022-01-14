require "rails_helper"

RSpec.describe Events::Users::Updated do
  let(:user) { create(:user) }

  subject { described_class.new(user: user) }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).not_to be_nil
  end

  describe "#schema" do
    it "defines the event schema" do
      expect(subject.schema).not_to eq({})
    end

    it "requires a record" do
      expect(JSON.parse(subject.schema)["name"]).to eq("user")
    end

    it "requires an operation attribute" do
      expect(JSON.parse(subject.schema)["fields"][3]["name"]).to eq("op")
      expect(JSON.parse(subject.schema)["fields"][3]["type"]["type"]).to eq("enum")
    end

    it "requires an ts_ms attribute representing the time of the event" do
      expect(JSON.parse(subject.schema)["fields"][4]["name"]).to eq("ts_ms")
      expect(JSON.parse(subject.schema)["fields"][4]["type"]["type"]).to eq("long")
    end

    context "before block" do
      let(:block) { JSON.parse(subject.schema)["fields"][0] }

      it "is required" do
        expect(block["name"]).to eq("before")
      end

      it "requires attributes" do
        # team_id
        expect(block["type"]["fields"][0]["name"]).to eq("team_id")
        expect(block["type"]["fields"][0]["type"]).to eq("int")
      end
    end

    context "after block" do
      let(:block) { JSON.parse(subject.schema)["fields"][1] }

      it "is required" do
        expect(block["name"]).to eq("after")
      end

      it "requires attributes" do
        # team_id
        expect(block["type"]["fields"][0]["name"]).to eq("team_id")
        expect(block["type"]["fields"][0]["type"]).to eq("int")
      end
    end

    context "source block" do
      let(:block) { JSON.parse(subject.schema)["fields"][2] }

      it "is required" do
        expect(block["name"]).to eq("source")
      end

      # rubocop:disable RSpec/MultipleExpectations
      it "requires attributes" do
        # version
        expect(block["type"]["fields"][0]["name"]).to eq("version")
        expect(block["type"]["fields"][0]["type"]).to eq("string")
        # name
        expect(block["type"]["fields"][1]["name"]).to eq("name")
        expect(block["type"]["fields"][1]["type"]).to eq("string")
        # ts_ms (represents the time the record was persisted in the db)
        expect(block["type"]["fields"][2]["name"]).to eq("ts_ms")
        expect(block["type"]["fields"][2]["type"]["type"]).to eq("long")
        # table
        expect(block["type"]["fields"][3]["name"]).to eq("table")
        expect(block["type"]["fields"][3]["type"]).to eq("string")
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe "#payload" do
    it "returns a payload valid against the schema" do
      expect {
        Avro::Schema.validate(subject.encoded_schema, subject.payload)
      }.not_to raise_error
    end

    it "includes the user's team id" do
      expect(subject.payload[:after][:team_id]).to eq(user.team.id)
    end

    it "includes the user created_at timestamp" do
      expect(subject.payload[:source][:ts_ms]).to eq((user.created_at.to_f * 1000).to_i)
    end

    it "includes the user table name" do
      expect(subject.payload[:source][:table]).to eq(user.class.table_name)
    end

    it "includes the operation" do
      expect(subject.payload[:op]).to eq('u')
    end

    it "includes the event timestamp" do
      expect(subject.payload[:ts_ms]).not_to eq(nil)
      expect(subject.payload[:ts_ms].to_s.size).to eq(13) # includes milliseconds
    end
  end
end
