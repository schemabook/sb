class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :activity_log

  validates :user_id, presence: true
  validates :activity_log_id, presence: true
  validates :title, presence: true
  validates :detail, presence: true

  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :for_service, ->(service_id) { where(resource_class: 'Service', resource_id: service_id) }
  scope :for_teams, -> { where(resource_class: 'Team') }
  scope :for_schema, ->(schema) { where(resource_class: 'Schema', resource_id: schema.id) }
  scope :for_schema_new, -> { where(resource_class: 'Schema') }
  scope :for_business, ->(business) { where(resource_class: 'Business', resource_id: business.id) }
  scope :for_invitations, -> { where(title: "Invited Teammate") }
  scope :for_service_team, ->(team) { where(resource_class: 'Service', resource_id: team.services.pluck(&:id)) }
  scope :for_team, lambda { |team|
    where(resource_class: 'Service', resource_id: team.services.pluck(:id))
      .or(where(resource_class: 'Schema', resource_id: team.schemas.pluck(:id)))
      .or(where(resource_class: 'Team', resource_id: team.id))
  }

  def resource
    resource_class.constantize.find(resource_id)
  end
end
