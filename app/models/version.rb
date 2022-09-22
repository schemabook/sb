class Version < ApplicationRecord
  has_one_attached :raw_body
  has_many :comments

  belongs_to :schema

  validate :body_format

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

  private

  def filename
    # example: my-schema+v1.json
    version_id = new_record? ? 1 : id
    # TODO: inject these attrs
    "#{schema.name.gsub(' ', '-')}+v#{version_id}.#{schema.format.file_type}"
  end

  def body_format
    return true if body.nil?
    return true if schema.nil?

    validator = schema.format.validator.constantize
    validator.validate(body, self)
  end
end
