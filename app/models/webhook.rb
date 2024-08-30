class Webhook < ApplicationRecord
  belongs_to :user
  belongs_to :schema

  validates :url, presence: true

  # TODO: validate the url is valid
end
