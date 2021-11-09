class Format < ActiveRecord::Base
  enum file_type: [:json, :avro, :csv]

  VALIDATORS = {
    "json" => "JsonValidator",
    "avro" => "AvroValidator",
    "csv"  => "CsvValidator"
  }

  validates :file_type, presence: true

  before_save { self.name = file_type.to_s }

  #def validated?(schema_body)
    #validator = VALIDATORS[self.file_type].constantize

    #validator.new(schema_body: schema_body).valid?
  #end
end
