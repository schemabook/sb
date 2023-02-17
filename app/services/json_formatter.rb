class JsonFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_json
    version.body
  end

  def to_avro
    begin
      Avro::Schema.parse(version.body).to_json
    rescue => e
      raise ConversionError, "The JSON definition can't be converted to Avro - #{e.message}"
    end
  end

  def to_csv
    begin
      headers  = csv_headers
      rows     = csv_rows(headers)

      csv_string(headers, rows)
    rescue => e
      raise ConversionError, "The JSON can't be converted to CSV due to lack of properties and types defined: #{e.message}"
    end
  end

  private

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
          # NOTE: CSV is a flat structure and doesn't support nesting of data
          raise ConversionError, "CSV does not support nesting" if key == "type" && field[key].is_a?(Hash)

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
