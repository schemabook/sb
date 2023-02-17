class CsvFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_csv
    version.body
  end

  def to_json
    str = headers.presence || version.body

    CSV.parse(str, col_sep: delimiter).to_json
  end

  def to_avro
    begin
      # NOTE: assumes all types are strings
      Avro::Schema.parse(json_string).to_json
    rescue => e
      raise ConversionError, "The CSV body can't be converted to Avro - #{e.message}"
    end
  end

  private

  def headers
    return "" unless version.body.match?(/\\n/)

    version.body.match(/(^.*)\\n/)[0].gsub("\\n", "")
  end

  def delimiter
    version.body.match(/\W/)[0]
  end

  # rubocop:disable Metrics/MethodLength
  def json_string
    str = headers.presence || version.body

    # split on a dynamic delimiter
    fields = str.split(delimiter)

    # start of json hash definition
    json = {
      "type" => "record",
      "name" => "schema",
      "fields" => []
    }

    fields.each do |field|
      field_hash = {
        "name" => field,
        "type" => "string"
      }

      json["fields"] << field_hash
    end

    return json.to_json
  end
  # rubocop:enable Metrics/MethodLength
end
