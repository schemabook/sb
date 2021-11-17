class AvroValidator
  def self.validate(body)
    begin
      Avro::Schema.parse(body)
      true
    rescue # can fail JSON parsing as well as Avro parsing
      false
    end
  end
end
