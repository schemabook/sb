class JsonValidator
  def self.validate(body)
    JSON.parse(body)
    true
  rescue JSON::ParserError
    false
  end
end
