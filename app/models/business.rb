class Business < ApplicationRecord
  include PublicIdGenerator

  has_many :users
  has_many :teams

  has_one :activity_log

  validates :name, presence: true
  validates :name, uniqueness: true

  def to_s
    name
  end

  def schemas
    team_ids = teams.pluck(:id)

    Schema.where(team_id: team_ids)
  end

  def services
    team_ids = teams.pluck(:id)

    Service.where(team_id: team_ids)
  end
end
