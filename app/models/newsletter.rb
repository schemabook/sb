class Newsletter < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: Devise.email_regexp
end
