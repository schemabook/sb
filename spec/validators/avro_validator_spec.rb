require 'rails_helper'

RSpec.describe AvroValidator do

  describe "self.validate" do
    context "with valid avro" do
      # validate json string matching avro parsing standards
      let(:body) do
        {
          type: "record",
          name: "RootRecord",
          fields: [
            {
              name: "field1",
              type: {
                type: "record",
                name: "InnerRecord",
                fields: []
              }
            },
            {
              name: "field2",
              type: "InnerRecord"
            }
          ]
        }.to_json
      end

      it "returns true" do
        expect(described_class.validate(body)).to be(true)
      end
    end

    context "with invalid avro" do
      # valid json but invalid avro field name
      let(:body) do
        {
          type: "record",
          name: "my-invalid-name",
          fields: [
            {
              name: "id",
              type: "int"
            }
          ]
        }.to_json
      end

      it "returns false" do
        expect(described_class.validate(body)).to be(false)
      end
    end
  end
end
