class Team < ApplicationRecord
  ADMIN_TEAM_NAME = "Administrators"

  has_many :users
  belongs_to :business

  validates :business_id, presence: true
end
