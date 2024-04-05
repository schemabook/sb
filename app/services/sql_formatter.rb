class SqlFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_csv
    raise ConversionError, "The SQL body can't be converted to CSV"
  end

  def to_json
    raise ConversionError, "The SQL body can't be converted to JSON"
  end

  def to_avro
    raise ConversionError, "The SQL body can't be converted to Avro"
  end

  def to_sql
    version.body
  end
end
