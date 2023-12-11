module Entities
  class ServiceEntity < Grape::Entity
    expose :name
    expose :description, documentation: { type: 'string', desc: 'Description of Service by managing team' }
    expose :public_id, as: :id
    expose :created_at
  end
end
