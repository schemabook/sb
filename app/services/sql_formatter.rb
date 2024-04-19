class SqlFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_csv #rubocop:disable Metrics/MethodLength
    begin
      body = @version.body

      raise ConversionError, "The SQL body can't reliably be converted to CSV because statement doesn't CREATE TABLE" unless body.match(/CREATE TABLE/)

      first_paren = body.index("(")
      last_paren = body.rindex(")")

      raise ConversionError, "The SQL body can't reliably be converted to CSV because statement doesn't include () after CREATE TABLE" unless first_paren && last_paren

      columns = body[first_paren + 1..last_paren - 1].strip
      headers = csv_headers(columns)
      rows    = csv_rows

      csv_string(headers, rows)
    rescue => e
      raise ConversionError, "The SQL can't be converted to CSV: #{e.message}"
    end
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

  private

  def csv_headers(columns)
    headers = []

    columns_arr = columns.split(",")

    columns_arr.each do |column|
      title, _data_type = column.split

      headers << title
    end

    headers.uniq.compact
  end

  def csv_rows
    # TODO: support insert statements with data
    []
  end

  def csv_string(headers, _rows)
    CSV.generate do |csv|
      csv << headers.compact.uniq
    end
  end
end
