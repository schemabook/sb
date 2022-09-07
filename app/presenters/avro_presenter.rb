class AvroPresenter
  attr_reader :schema

  def initialize(schema)
    @schema = schema
  end

  def content
    if @schema.format.json?
      avro = SchemaFormatter.new(schema: @schema).as_avro
      json = JSON.parse(avro) # avro is presented as JSON

      JSON.pretty_generate(json)
    else
      # TODO: if the original format was not json, convert it using the SchemaFormatter
      @schema.body
    end
  end

  def content_length
    content.lines.count
  end
end
