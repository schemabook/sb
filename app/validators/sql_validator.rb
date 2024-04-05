class SqlValidator
  def self.validate(body, klass = nil)
    errors(body)
    true
  rescue => e
    klass&.errors&.add(:body, "is not valid SQL: #{e.message.split(':').last}")

    false
  end

  def self.errors(body)
    begin
      PgQuery.parse(body)
      true
    rescue => e
      raise e
    end 
  end
end
