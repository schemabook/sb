class JsonPayloadValidator
  attr_accessor :schema, :payload

  def initialize(schema:, payload:)
    @schema = schema
    @payload = JSON.parse(payload.to_json)
  end

  def valid?
    begin
      Avro::Schema.validate(encoded_schema, cast_payload)
    rescue
      false
    end
  end

  def encoded_schema
    Avro::Schema.parse(schema)
  end

  # payload will come in as a string
  # it needs to be cast as a Ruby hash in order to validate
  def cast_payload
    JSON.parse(payload.gsub(/:([a-zA-z]+)/,'"\\1"').gsub('=>', ': ')).symbolize_keys
  end
end
