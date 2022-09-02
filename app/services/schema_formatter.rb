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

  def as_csv
    case schema.format.to_s
    when "json"
      json_to_csv
    end
  end

  private

  def json_to_avro
    begin
      Avro::Schema.parse(schema.body).to_json
    rescue => e
      raise ConversionError.new("JSON can't be formatted as Avro: #{e.message}")
    end
  end

  # TODO: update to support nesting
  def json_to_csv
    json     = JSON.parse(schema.body)
    headers  = []
    finalrow = []

    json.each do |h|
      next unless h&.last.is_a?(Array)
      next unless h&.last.first.is_a?(Hash)

      h.last.first.keys.each do |key|
        headers << key
      end
    end

    json.each do |h|
      next unless h&.last.is_a?(Array)
      next unless h&.last.first.is_a?(Hash)

      final = {}
      headers.compact.each do |key2|
        final[key2] = h.last.first[key2]
      end

      finalrow << final
    end

    csv_string = CSV.generate do |csv|
      csv << headers.compact.uniq

      finalrow.each do |deal|
        csv << deal.values
      end
    end
  end
end
