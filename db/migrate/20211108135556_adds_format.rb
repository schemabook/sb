class AddsFormat < ActiveRecord::Migration[6.1]
  def change
    create_table :formats do |t|
      t.string :name
      t.string :file_type

      t.timestamps
    end
  end
end


__END__

class Schema
  has_one :format

  def valid?
    format.valid?(self.body)
  end
end

class Format
  enum file_type: [:json, :avro, :csv]

  validations = {
    :json => "JsonValidator",
    :avro => "AvroValidator",
    :csv  => "CsvValidator"
  }

  def valid?(schema_body)
    validator = validations[self.file_type].constantize

    validator.new(schema_body: schema_body).valid?
  end
end

class JsonValidator
  attr_accessor :schema_body

  def initialize(schema_body: schema_body)
    @schema_body = schema_body
  end

  def valid?
    # TODO: pass schema body string through validation process
  end
end

schema.valid?





