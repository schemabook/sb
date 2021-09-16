class Team < ApplicationRecord
  ADMIN_TEAM_NAME = "Administrators"

  has_many :users
  belongs_to :business

  validates_presence_of :business_id
end
