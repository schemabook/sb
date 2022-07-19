class ActivityLog < ApplicationRecord
  belongs_to :business

  has_many :activities

  def for_user(user_id:)
    activities.for_user(user_id).order(created_at: :desc)
  end

  def for_service(service_id:)
    activities.for_service(service_id).order(created_at: :desc)
  end

  def for_team(team:)
    activities.for_team(team).order(created_at: :desc)
  end

  def for_teams
    activities.for_teams.order(created_at: :desc)
  end

  def for_schema(schema:)
    activities.for_schema(schema).order(created_at: :desc)
  end

  def for_schema_new
    activities.for_schema_new.order(created_at: :desc)
  end

  def for_business(business:)
    activities.for_business(business).order(created_at: :desc)
  end

  def for_invitations
    activities.for_invitations.order(created_at: :desc)
  end

  def for_service_team(team:)
    activities.for_service_team(team).order(created_at: :desc)
  end
end
