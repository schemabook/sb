module Entities
  class Error < Grape::Entity
    expose :status, documentation: { type: Integer }
    expose :error, documentation: { type: String }
  end
end
