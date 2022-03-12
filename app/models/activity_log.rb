class ActivityLog < ApplicationRecord
  belongs_to :business

  has_many :activities

  validates :business_id, presence: true

  def for_user(user_id:)
    activities.for_user(user_id)
  end

  def for_service(service_id:)
    activities.for_service(service_id)
  end

  def for_team(team:)
    activities.for_team(team)
  end

  def for_schema(schema:)
    activities.for_schema(schema)
  end

  def for_business(business:)
    activities.for_business(business)
  end

end
