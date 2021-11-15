class JsonValidator
  def self.validate(body)
    begin
      JSON.parse(body)
      return true
    rescue JSON::ParserError
      return false
    end
  end
end
