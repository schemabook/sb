class JsonValidator
  def self.validate(body, klass = nil)
    self.errors(body)
    true
  rescue => e
    klass.errors.add(:body, "is not valid JSON: #{e.message.split(":").last}") unless klass.nil?

    false
  end

  def self.errors(body)
    metaschema = JSON::Validator.validator_for_name("draft4").metaschema
    JSON::Validator.validate(metaschema, JSON.parse(body))
  end
end
