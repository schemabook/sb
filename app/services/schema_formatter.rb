class SchemaFormatter
  class ConversionError < StandardError; end

  FORMATTERS = {
    json: JsonFormatter,
    csv: CsvFormatter,
    avro: AvroFormatter
  }

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def formatter
    FORMATTERS[schema.format.to_s.to_sym].new(schema:, version:)
  end

  def as_json
    formatter.to_json
  end

  def as_csv
    formatter.to_csv
  end

  def as_avro
    formatter.to_avro
  end
end
