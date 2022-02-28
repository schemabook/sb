class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :activity_log

  validates :user_id, presence: true
  validates :activity_log_id, presence: true
  validates :title, presence: true
  validates :detail, presence: true

  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :for_service, ->(service_id) { where(resource_class: 'Service', resource_id: service_id) }
  scope :for_team, ->(team) do
    where(resource_class: 'Service', resource_id: team.services.pluck(:id))
      .or(where(resource_class: 'Schema', resource_id: team.schemas.pluck(:id)))
  end

  def resource
    resource_class.constantize.find(resource_id)
  end
end
