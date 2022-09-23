class JsonPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    return unless @schema.format.json?

    json = JSON.parse(@version.body)
    JSON.pretty_generate(json)
    # TODO: if format was originally something else, convert it using the SchemaFormatter
  end

  def content_length
    content.lines.count
  end
end
