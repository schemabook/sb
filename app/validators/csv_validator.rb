class CsvValidator
  def self.validate(body, klass = nil)
    CSV.parse(body)
    true
  rescue => e
    klass&.errors&.add(:body, "is not valid CSV: #{e.message.split(':').last}")
    false
  end
end
