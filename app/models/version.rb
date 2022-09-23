class Version < ApplicationRecord
  has_one_attached :raw_body
  has_many :comments

  belongs_to :schema

  validate :body_format

  delegate :name, to: :schema
  delegate :format, to: :schema

  def body=(value)
    @body = value

    raw_body.attach(
      io: StringIO.new(value),
      filename:,
      content_type: 'text/plain'
    )
  end

  def body
    @body ||= raw_body.try(:blob).try(:download)
  end

  # TODO: persist
  def version_index
    schema.versions.count + 1
  end

  # example: my-schema+v1.json
  def filename
    name       = self.name.gsub(' ', '-')
    file_type  = self.format.file_type

    "#{name}+v#{version_index}.#{file_type}"
  end

  def body_format
    return true if body.nil?
    return true if self.format.nil?

    validator = self.format.validator.constantize
    validator.validate(body, self)
  end
end
