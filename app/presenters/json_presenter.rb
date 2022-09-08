class JsonPresenter
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def content
    return unless @schema.format.json?

    json = JSON.parse(@schema.body)
    JSON.pretty_generate(json)
    # TODO: if format was originally something else, convert it using the SchemaFormatter
  end

  def content_length
    content.lines.count
  end
end
