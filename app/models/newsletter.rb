class Newsletter < ApplicationRecord
  MAILING_LIST = "newsletter@mg.schemabook.com"
  LIST_SALT = "newsletter_announcements"

  validates :email, presence: true, uniqueness: true, format: Devise.email_regexp
end
