class SchemaFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def as_json
    return version.body if schema.format.json?
  end

  def as_avro
    case schema.format.to_s
    when "avro"
      version.body
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
      Avro::Schema.parse(version.body).to_json
    rescue => e
      raise ConversionError, "The JSON definition can't be converted to Avro - #{e.message}"
    end
  end

  # TODO: update to support nesting
  def json_to_csv
    begin
      headers  = csv_headers
      finalrow = csv_finalrow(headers)

      csv_string(headers, finalrow)
    rescue
      raise ConversionError, "The JSON can't be converted to CSV due to lack of properties and types defined"
    end
  end

  def csv_headers
    headers = []

    JSON.parse(version.body).each do |h|
      next unless json_hash?(h)

      element = h.last.first

      element.each_key { |key| headers << key }
    end

    headers.compact
  end

  def csv_finalrow(headers)
    finalrow = []

    JSON.parse(version.body).each do |h|
      next unless json_hash?(h)

      final = {}
      headers.each { |key2| final[key2] = h.last.first[key2] }
      finalrow << final
    end

    finalrow
  end

  def json_hash?(element)
    element&.last.is_a?(Array) || element&.last&.first.is_a?(Hash)
  end

  def csv_string(headers, finalrow)
    CSV.generate do |csv|
      csv << headers.compact.uniq

      finalrow.each { |deal| csv << deal.values }
    end
  end
end
