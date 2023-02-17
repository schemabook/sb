class AvroFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_avro
    version.body
  end

  def to_json
    begin
      Avro::Schema.parse(version.body).to_json
    rescue => e
      raise ConversionError, "The Avro definition can't be converted to JSON - #{e.message}"
    end
  end

  # TODO: guard against schemas with nesting
  def to_csv
    begin
      JsonFormatter.new(schema:, version:).to_csv
    rescue => e
      raise ConversionError, "The Avro definition can't be converted to CSV - #{e.message}"
    end
  end
end
