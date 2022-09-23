class CsvPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    if @schema.format.json?
      from_json.presence || "The JSON definition can't be converted to CSV"
    else
      # TODO: if original format was not json, convert it using the SchemaFormatter
      @version.body
    end
  end

  def content_length
    content.lines.count
  end

  def from_json
    begin
      SchemaFormatter.new(schema: @schema, version: @version).as_csv
    rescue => e
      return e.message
    end
  end
end
