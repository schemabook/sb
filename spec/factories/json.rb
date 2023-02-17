module SchemaFormat
  class Json
    attr_accessor :string

    def to_s
      string
    end
  end
end

FactoryBot.define do
  factory :json, class: "SchemaFormat::Json" do
    string { '{"foo": {"bar": 1}}' }
  end

  trait :with_types do
    string { '{"type": "record", "name":"book", "fields": [{ "name": "title", "type": "string" }]}' }
  end
end
