class AvroValidator
  def self.validate(body, klass = nil)
    Avro::Schema.parse(body)
    true
  rescue => e
    klass&.errors&.add(:body, "is not valid Avro: #{e.message.split(':').last}")

    false
  end
end
