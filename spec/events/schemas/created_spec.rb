require "rails_helper"

RSpec.describe Events::Schemas::Created do
  let(:format)   { create(:format, file_type: :json) }
  let(:json)     { '{"foo": {"bar": 1}}' }
  let(:schema)   { create(:schema, :with_team, name: "foo", file_type: "json", body: json, format:) }

  subject { described_class.new(record: schema) }

  it "defines an event name" do
    expect(subject.class::EVENT_NAME).not_to be_nil
  end

  describe "#schema" do
    it "defines the event schema" do
      expect(subject.schema).not_to eq({})
    end

    it "requires a record" do
      expect(JSON.parse(subject.schema)["name"]).to eq("schema")
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

      it "is optional" do
        expect(block["name"]).to eq("before")
      end
    end

    context "after block" do
      let(:block) { JSON.parse(subject.schema)["fields"][1] }

      it "is required" do
        expect(block["name"]).to eq("after")
      end

      it "requires attributes" do
        # id
        expect(block["type"]["fields"][0]["name"]).to eq("id")
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

    it "includes the schema id" do
      expect(subject.payload[:after][:id]).to eq(schema.id)
    end

    it "includes the schema created_at timestamp" do
      expect(subject.payload[:source][:ts_ms]).to eq((schema.created_at.to_f * 1000).to_i)
    end

    it "includes the schema table name" do
      expect(subject.payload[:source][:table]).to eq(schema.class.table_name)
    end

    it "includes the operation" do
      expect(subject.payload[:op]).to eq('c')
    end

    it "includes the event timestamp" do
      expect(subject.payload[:ts_ms]).not_to be_nil
      expect(subject.payload[:ts_ms].to_s.size).to eq(13) # includes milliseconds
    end
  end
end
