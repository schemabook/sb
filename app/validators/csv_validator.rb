class CsvValidator
  def self.validate(body)
    begin
      CSV.parse(body)
      true
    rescue ArgumentError
      false
    rescue CSV::MalformedCSVError
      false
    end
  end
end
