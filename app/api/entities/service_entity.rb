module Entities
  class ServiceEntity < Grape::Entity
    expose :name
    expose :description, documentation: { type: 'string', desc: 'Description of Service by managing team' }
    expose :public_id, as: :id
    expose :team_name
    expose :team_email
    expose :team_channel
    expose :created_at
  end
end
