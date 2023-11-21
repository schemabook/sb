class Schemas < API::Root
  desc "Schemas endpoints"

  namespace :schemas do
    desc "Collection of all of a companies schemas" do
      summary "The response will include an array containing all of a company's schemas"
      detail 'Based on the authentication token, all of the schemas the user has access to will be returned'
      named 'API::Schemas'
      deprecated false
      is_array true
      nickname 'index'
      produces ['application/json']
      consumes ['application/json']
      tags ['Schemas']
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

    # create
    desc 'Create a Schema.' do
      summary 'A schema defines the structure of the data your service provides.'
      detail 'A schema can be defined in various formats: json, avro, csv'
      entity Entities::SchemaEntity
      named 'API::Schema'
      deprecated false
      is_array false
      nickname 'create'
      produces ['application/json']
      consumes ['application/json']
      tags ['Schemas']
      failure [
        [400, 'Bad Request', Entities::Error],
        [401, 'Unauthorized', Entities::Error],
        [403, 'Forbidden', Entities::Error],
        [404, 'Not Found', Entities::Error],
        [415, 'Unsupported Media Type', Entities::Error],
        [429, 'Too Many Requests', Entities::Error]
      ]
      headers \
        Authorization: {
          description: "API token",
          required: true
        }
    end

    params do
      requires :name, type: String, desc: "Name for the new Schema"
      requires :service_id, type: String, desc: "The id of the service to associate the schema with"
      requires :production, type: Boolean, desc: "A boolean representing if this is production data"
      requires :format, type: String, desc: "The format type of the body: json, avro, csv"
      requires :body, type: String, desc: "The schema definition in plain text"
    end

    post "/" do
      # locate the service (user has to be associated with it)
      service = @user&.team&.services&.find_by(public_id: params[:service_id])

      # define the format
      format = Format.find_by!(name: params[:format])

      # define schema
      schema = @user&.business&.schemas&.create!(
        name: params[:name],
        service_id: service.id,
        production: params[:production],
        format_id: format.id
      )

      # define the initial version
      version = Version.new(schema_id: schema.id)
      version.body = params[:body]
      version.save!

      # reload the ids
      schema.reload

      present schema, with: Entities::SchemaEntity
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
