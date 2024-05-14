class JsonPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    begin
      formatted_content = SchemaFormatter.new(schema:, version:).as_json

      json = JSON.parse(formatted_content)
      JSON.pretty_generate(json)
    rescue
      "Original format can not be converted to JSON at this time"
    end
  end

  def content_length
    content.lines.count
  end
end
