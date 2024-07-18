class SqlValidator
  def self.validate(body, klass = nil)
    errors(body)
    true
  rescue => e
    klass&.errors&.add(:body, "is not valid SQL: #{e.message.split(':').last}")

    false
  end

  def self.errors(body)
    PgQuery.parse(body)
    true
  end
end
