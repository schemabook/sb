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
    Schema.where(team_id: team_ids)
  end

  def services
    Service.where(team_id: team_ids)
  end

  def team_ids
    teams.pluck(:id)
  end

  def subscribed?
    return false if subscribed_at.nil? # not subscribed ever

    return true if DateTime.now < subscribed_at + 30.days # subscribed less than 30 days ago

    return true if cancelled_at.nil? || cancelled_at < DateTime.now + 30.days # cancelled less than 30 days ago

    return false
  end

  def cancelled?
    return false if cancelled_at.nil?

    return true
  end
end
