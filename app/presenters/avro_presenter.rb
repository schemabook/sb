class AvroPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    begin
      avro = SchemaFormatter.new(schema: @schema, version: @version).as_avro
      json = JSON.parse(avro) # avro is presented as JSON

      JSON.pretty_generate(json)
    rescue
      return "Original format can not be converted to Avro at this time"
    end
  end

  def content_length
    content.lines.count
  end
end
