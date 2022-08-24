class JsonValidator
  DRAFT = "draft4"

  def self.validate(body, klass = nil)
    errors(body)
    true
  rescue => e
    klass&.errors&.add(:body, "is not valid JSON: #{e.message.split(':').last}")

    false
  end

  def self.errors(body)
    metaschema = JSON::Validator.validator_for_name(DRAFT).metaschema
    JSON::Validator.validate(metaschema, JSON.parse(body))
  end
end
