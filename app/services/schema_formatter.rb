class SchemaFormatter
  class ConversionError < StandardError; end

  attr_reader :schema

  def initialize(schema:)
    @schema = schema
  end

  def as_json
    return schema.body if schema.format.json?

  end

  def as_avro
    case schema.format.to_s
    when "avro"
      schema.body
    when "json"
      json_to_avro
    end
  end

  private

  def json_to_avro
    begin
      Avro::Schema.parse(schema.body)
    rescue => e
      raise ConversionError.new("JSON can't be formatted as Avro: #{e.message}")
    end
  end
end
