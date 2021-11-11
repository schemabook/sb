class Format < ApplicationRecord
  enum file_type: {
    json: 0,
    avro: 1,
    csv: 2
  }

  VALIDATORS = {
    "json" => "JsonValidator",
    "avro" => "AvroValidator",
    "csv" => "CsvValidator"
  }

  validates :file_type, presence: true

  before_save do
    self.name = file_type.to_s
  end
end
