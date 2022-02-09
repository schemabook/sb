class ActivityLog < ApplicationRecord
  belongs_to :business

  has_many :activities

  validates :business_id, presence: true

  def for_user(user_id:)
    activities.for_user(user_id)
  end
end
