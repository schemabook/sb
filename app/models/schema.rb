class Schema < ApplicationRecord
  include PublicIdGenerator

  UNPAID_LIMIT = 10

  has_many :stakeholders
  has_many :favorites
  has_many :versions

  belongs_to :team
  belongs_to :service, optional: true
  belongs_to :format

  validates :name, presence: true, uniqueness: {scope: :service_id}, length: {in: 2..120}
end
