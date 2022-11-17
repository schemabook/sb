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

  # TODO: update to support nesting, currently assumes a root level list of attributes/fields
  def json_to_csv
    begin
      headers  = csv_headers
      rows     = csv_rows(headers)

      csv_string(headers, rows)
    rescue
      raise ConversionError, "The JSON can't be converted to CSV due to lack of properties and types defined"
    end
  end

  def csv_headers
    headers = []

    JSON.parse(version.body).each do |h|
      next unless json_hash?(h)

      fields = Array.wrap(h.last)
      fields.each do |field|
        field.each_key do |key|
          headers << key
        end
      end
    end

    headers.uniq.compact
  end

  # rubocop:disable Metrics/MethodLength
  def csv_rows(headers)
    rows = []

    JSON.parse(version.body).each do |h|
      next unless json_hash?(h)

      fields = Array.wrap(h.last)

      fields.each do |field|
        row = {}

        headers.each do |key|
          row[key] = field.fetch(key, "") # blank string if not found
        end

        rows << row
      end
    end

    rows
  end
  # rubocop:enable Metrics/MethodLength

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
