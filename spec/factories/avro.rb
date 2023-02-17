module SchemaFormat
  class Avro
    attr_accessor :string

    def to_s
      string
    end
  end
end

FactoryBot.define do
  factory :avro, class: "SchemaFormat::Avro" do
    string do
      '{
        "name": "person",
        "type": "record",
        "fields": [
          {
            "name": "first_name",
            "type": "string"
          },
          {
            "name": "last_name",
            "type": "string"
          },
          {
            "name": "age",
            "type": "int"
          }
        ]
      }'
    end
  end

  trait :nested do
    string do
      '{
        "name": "person",
        "type": "record",
        "fields": [
          {
            "name": "name",
            "type": "string"
          },
          {
            "name": "address",
            "type": {
              "name": "address",
              "type": "record",
              "fields": [
                { "name": "addr1", "type": "string" },
                { "name": "addr2", "type": "string" },
                { "name": "city", "type": "string" },
                { "name": "zip", "type": "string" }
              ]
            }
          }
        ]
      }'
    end
  end
end
