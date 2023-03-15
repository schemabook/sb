class CsvPayloadValidator
  attr_accessor :schema, :payload

  def initialize(schema:, payload:)
    @schema  = schema
    @payload = payload
  end

  def valid?
    headers_and_body = "#{schema}\n#{payload}"

    begin
      csv = CSV.parse(headers_and_body, headers: true)

      # NOTE: a nil means something didn't align between the headers and the rows
      !csv.to_a.flatten.any?(nil)
    rescue
      false
    end
  end
end
