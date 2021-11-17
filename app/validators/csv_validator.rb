class CsvValidator
  def self.validate(body)
    CSV.parse(body)
    true
  rescue
    false
  end
end
