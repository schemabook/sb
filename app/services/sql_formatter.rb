class SqlFormatter
  class ConversionError < StandardError; end

  attr_reader :schema, :version

  def initialize(schema:, version:)
    @schema  = schema
    @version = version
  end

  def to_csv
    begin
      body = @version.body

      if body.match(/CREATE TABLE/)
        first_paren = body.index("(")
        last_paren = body.rindex(")")

        raise ConversionError, "The SQL body can't reliably be converted to CSV because statement doesn't include () after CREATE TABLE" unless first_paren && last_paren

        columns = body[first_paren + 1..last_paren - 1].strip
        headers = csv_headers(columns)
        rows    = csv_rows(headers)

        csv_string(headers, rows)
      else
        # NOTE: support UPDATE statements in the future
        raise ConversionError, "The SQL body can't reliably be converted to CSV because statement doesn't CREATE TABLE"
      end
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
      title, data_type = column.split(" ")

      headers << title
    end

    headers.uniq.compact
  end

  def csv_rows(headers)
    rows = []

    # TODO: support insert statements with data
    rows
  end

  def csv_string(headers, rows)
    CSV.generate do |csv|
      csv << headers.compact.uniq
    end
  end

end
