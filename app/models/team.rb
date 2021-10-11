class Team < ApplicationRecord
  ADMIN_TEAM_NAME = "Administrators" # created when business is created

  has_many :users
  belongs_to :business

  validates :business_id, presence: true
  validates :name, uniqueness: { scope: :business }

  def admin?
    name == ADMIN_TEAM_NAME
  end
end
