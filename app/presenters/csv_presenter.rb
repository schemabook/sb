class CsvPresenter
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def content
    if @schema.format.json?
      from_json.blank? ? "The JSON definition can't be converted to CSV" : from_json
    else
      # TODO: if original format was not json, convert it using the SchemaFormatter
      @schema.body
    end
  end

  def content_length
    content.lines.count
  end

  def from_json
    begin
      SchemaFormatter.new(schema: @schema).as_csv
    rescue => e
      return e.message
    end
  end
end
