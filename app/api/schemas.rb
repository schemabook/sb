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
      failure [
        [400, "Bad Request", Entities::Error],
        [401, "Unauthorized", Entities::Error],
        [429, "Too Many Requests", Entities::Error]
      ]
      headers \
        Authorization: {
          description: "API token",
          required: true
        }

    end

    # index
    get do
      schemas = @user&.business&.schemas&.all

      present schemas, with: Entities::SchemaEntity
    end

    namespace ":id" do
      params do
        requires :id, type: String, desc: "Schema ID"
      end

      desc "Schema attributes" do
        detail "Version and data contract attributes of a schema"
        entity Entities::SchemaEntity
        nickname 'show'
        produces ['application/json']
        consumes ['application/json']
        tags ['schemas']

        failure [
          [401, "Unauthorized", Entities::Error],
          [403, "Forbidden", Entities::Error],
          [404, "Not Found", Entities::Error],
          [429, "Too Many Requests", Entities::Error]
        ]
        headers \
          Authorization: {
            description: "API token",
            required: true
          }
      end

      get "/" do
        schema = @user&.business&.schemas&.find_by!(public_id: params[:id])

        present schema, with: Entities::SchemaEntity
      end
    end
  end
end
