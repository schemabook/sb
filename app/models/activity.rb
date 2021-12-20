class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :activity_log

  validates :user_id, presence: true
  validates :activity_log_id, presence: true
  validates :title, presence: true
  validates :detail, presence: true
end
