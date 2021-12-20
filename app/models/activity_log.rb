class ActivityLog < ApplicationRecord
  belongs_to :business

  validates :business_id, presence: true
end
