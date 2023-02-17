class CsvPresenter
  attr_reader :schema, :version

  def initialize(schema, version)
    @schema = schema
    @version = version
  end

  def content
    begin
      SchemaFormatter.new(schema: @schema, version: @version).as_csv
    rescue
      return "Original format can not be converted to CSV"
    end
  end

  def content_length
    content.lines.count
  end
end
