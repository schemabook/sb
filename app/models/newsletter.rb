class Newsletter < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates_format_of :email,:with => Devise::email_regexp
end
