class Webhook < ApplicationRecord
  include ActiveModel::Validations
  validates_with Validators::UrlValidator

  belongs_to :user
  belongs_to :schema

  validates :url, presence: true
end
