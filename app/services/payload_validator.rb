class PayloadValidator
  attr_accessor :schema, :version_body, :file_type, :payload

  VALIDATORS = {
    avro: AvroPayloadValidator,
    json: JsonPayloadValidator,
    csv: CsvPayloadValidator
  }

  def initialize(schema:, payload:)
    @schema = schema
    @version_body = schema.versions.last.body
    @file_type = schema.format.file_type
    @payload = payload
  end

  def valid?
    begin
      VALIDATORS[file_type.to_sym].new(schema: version_body, payload:).valid?
    rescue
      false
    end
  end
end
