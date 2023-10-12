class Schemas < API::Root
  desc "Schemas endpoints"

  namespace :schemas do
    desc "Collection of all of a companies schemas" do
      summary "The response will include an array containing all of a company's schemas"
      detail 'Based on the authentication token, all of the schemas the user has access to will be returned'
      failure [[401, 'Unauthorized', 'Entities::Error']]
      named 'API::Schemas'
      deprecated false
      is_array true
      nickname 'index'
      produces ['application/json']
      consumes ['application/json']
      tags ['schemas']
    end

    get do
      schemas = @user&.business.schemas.all

      present schemas, with: Entities::SchemaEntity
    end
  end
end
