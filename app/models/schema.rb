class Schema < ApplicationRecord
  attr_accessor :file_type

  has_one_attached :raw_body
  has_many :stakeholders
  has_many :comments
  has_many :favorites

  belongs_to :team
  belongs_to :service, optional: true
  belongs_to :format

  validates :name, presence: true, uniqueness: { scope: :service_id }, length: { in: 2..120 }
  validates :raw_body, presence: true
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
    "#{name.gsub(' ', '-')}.#{file_type}"
  end

  def body_format
    return true if body.nil?

    validator = format.validator

    if validator.constantize.validate(body)
      true
    else
      errors.add :body, "is not valid #{file_type}"

      false
    end
  end
end
