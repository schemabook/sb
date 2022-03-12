require "rails_helper"

RSpec.describe Events::Businesses::Updated do
  let(:business) { create(:business) }
  let(:user)     { create(:user) }

  subject { described_class.new(business: business, user: user) }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).not_to be_nil
  end

  describe "#schema" do
    it "defines the event schema" do
      expect(subject.schema).not_to eq({})
    end

    it "requires a record" do
      expect(JSON.parse(subject.schema)["name"]).to eq("business")
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

      # rubocop:disable RSpec/ExampleLength
      # rubocop:disable RSpec/MultipleExpectations
      it "requires attributes" do
        # id
        expect(block["type"]["fields"][0]["name"]).to eq("id")
        expect(block["type"]["fields"][0]["type"]).to eq("int")

        # name
        expect(block["type"]["fields"][1]["name"]).to eq("name")
        expect(block["type"]["fields"][1]["type"]).to eq("string")

        # street_address
        expect(block["type"]["fields"][2]["name"]).to eq("street_address")
        expect(block["type"]["fields"][2]["type"]).to eq(["null", "string"])

        # city
        expect(block["type"]["fields"][3]["name"]).to eq("city")
        expect(block["type"]["fields"][3]["type"]).to eq(["null", "string"])

        # state
        expect(block["type"]["fields"][4]["name"]).to eq("state")
        expect(block["type"]["fields"][4]["type"]).to eq(["null", "string"])

        # postal
        expect(block["type"]["fields"][5]["name"]).to eq("postal")
        expect(block["type"]["fields"][5]["type"]).to eq(["null", "string"])

        # country
        expect(block["type"]["fields"][6]["name"]).to eq("country")
        expect(block["type"]["fields"][6]["type"]).to eq(["null", "string"])

        # actor id
        expect(block["type"]["fields"][7]["name"]).to eq("actor_id")
        expect(block["type"]["fields"][7]["type"]).to eq("int")
      end
      # rubocop:enable RSpec/MultipleExpectations
      # rubocop:enable RSpec/ExampleLength
    end

    context "after block" do
      let(:block) { JSON.parse(subject.schema)["fields"][1] }

      it "is required" do
        expect(block["name"]).to eq("after")
      end

      # rubocop:disable RSpec/MultipleExpectations
      # rubocop:disable RSpec/ExampleLength
      it "requires attributes" do
        # id
        expect(block["type"]["fields"][0]["name"]).to eq("id")
        expect(block["type"]["fields"][0]["type"]).to eq("int")

        # name
        expect(block["type"]["fields"][1]["name"]).to eq("name")
        expect(block["type"]["fields"][1]["type"]).to eq("string")

        # street_address
        expect(block["type"]["fields"][2]["name"]).to eq("street_address")
        expect(block["type"]["fields"][2]["type"]).to eq(["null", "string"])

        # city
        expect(block["type"]["fields"][3]["name"]).to eq("city")
        expect(block["type"]["fields"][3]["type"]).to eq(["null", "string"])

        # state
        expect(block["type"]["fields"][4]["name"]).to eq("state")
        expect(block["type"]["fields"][4]["type"]).to eq(["null", "string"])

        # postal
        expect(block["type"]["fields"][5]["name"]).to eq("postal")
        expect(block["type"]["fields"][5]["type"]).to eq(["null", "string"])

        # country
        expect(block["type"]["fields"][6]["name"]).to eq("country")
        expect(block["type"]["fields"][6]["type"]).to eq(["null", "string"])

        # actor id
        expect(block["type"]["fields"][7]["name"]).to eq("actor_id")
        expect(block["type"]["fields"][7]["type"]).to eq("int")
      end
      # rubocop:enable RSpec/ExampleLength
      # rubocop:enable RSpec/MultipleExpectations
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

      it "has optional attributes" do
        # query
        expect(block["type"]["fields"][4]["name"]).to eq("query")
        expect(block["type"]["fields"][4]["type"][0]).to eq("null")
        expect(block["type"]["fields"][4]["type"][1]).to eq("string")
      end
    end
  end

  describe "#payload" do
    it "returns a payload valid against the schema" do
      expect {
        Avro::Schema.validate(subject.encoded_schema, subject.payload)
      }.not_to raise_error
    end

    it "includes the business id" do
      expect(subject.payload[:after][:id]).to eq(business.id)
    end

    it "includes the business created_at timestamp" do
      expect(subject.payload[:source][:ts_ms]).to eq((business.created_at.to_f * 1000).to_i)
    end

    it "includes the business table name" do
      expect(subject.payload[:source][:table]).to eq(business.class.table_name)
    end

    it "includes the operation" do
      expect(subject.payload[:op]).to eq('c')
    end

    it "includes the event timestamp" do
      expect(subject.payload[:ts_ms]).not_to eq(nil)
      expect(subject.payload[:ts_ms].to_s.size).to eq(13) # includes milliseconds
    end
  end
end
