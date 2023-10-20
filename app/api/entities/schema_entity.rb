module Entities
  class SchemaEntity < Grape::Entity
    expose :name
    expose :description, documentation: { type: 'string', desc: 'Description of Schema by authoring team' }
    expose :public_id, as: :id
    expose :format, using: FormatEntity
    expose :created_at
    expose :production
  end
end
