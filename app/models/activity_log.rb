class ActivityLog < ApplicationRecord
  belongs_to :business

  has_many :activities

  validates :business_id, presence: true
end
