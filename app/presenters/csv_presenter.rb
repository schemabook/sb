class CsvPresenter
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def content
    if @schema.format.json?
      SchemaFormatter.new(schema: @schema).as_csv
    else
      # TODO: if original format was not json, convert it using the SchemaFormatter
    end
  end

  def content_length
    content.lines.count
  end
end
