class Schema < ApplicationRecord
  has_one_attached :raw_body

  attr_accessor :file_type, :body

  belongs_to :team
  belongs_to :service, optional: true
  belongs_to :format

  validates :name, presence: true, uniqueness: { scope: :service_id }, length: { in: 2..120 }
  validates :team_id, presence: true
  validates :format_id, presence: true
  validates :raw_body, presence: true
  validate :body_format

  def body=(value)
    @body = value

    raw_body.attach(
      io: StringIO.new(value),
      filename: filename,
      content_type: 'text/plain'
    )
  end

  def body
    @body ||= raw_body.try(:blob).try(:download)
  end

  private

  def filename
    "#{self.name.gsub(" ", "-")}.#{self.file_type}"
  end

  def body_format
    return true if self.body.nil?

    validator = format.validator

    if validator.constantize.validate(self.body)
      return true
    else
      self.errors.add :body, "is not valid JSON"

      return false
    end
  end
end
