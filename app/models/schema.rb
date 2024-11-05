class Schema < ApplicationRecord
  include PublicIdGenerator

  UNPAID_LIMIT = 10

  has_many :stakeholders
  has_many :favorites
  has_many :versions
  has_many :webhooks

  belongs_to :team
  belongs_to :service, optional: true
  belongs_to :format

  validates :name, presence: true, uniqueness: {scope: :service_id}, length: {in: 2..120}

  def url
    domain = $request.try(:base_url).nil? ? "" : $request.try(:base_url)

    "#{domain}/schemas/#{public_id}"
  end
end
