class AvroPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    from_json if @schema.format.json?
    # TODO: if the original format was not json, convert it using the SchemaFormatter
  end

  def content_length
    content.lines.count
  end

  def from_json
    begin
      avro = SchemaFormatter.new(schema: @schema, version: @version).as_avro
      json = JSON.parse(avro) # avro is presented as JSON

      JSON.pretty_generate(json)
    rescue => e
      return e.message
    end
  end
end
