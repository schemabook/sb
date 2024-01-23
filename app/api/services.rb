class Services < API::Root
  desc "Services endpoints"

  namespace :services do
    desc "Collection of all of a companies services" do
      summary "The response will include an array containing all of a company's services"
      detail "Based on the authentication token, all of the services the user has access to will be returned"
      named "API::Services"
      deprecated false
      is_array true
      nickname "index"
      produces ["application/json"]
      consumes ["application/json"]
      tags ["Services"]
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
      services = @user&.business&.services&.all

      present services, with: Entities::ServiceEntity
    end

    namespace ":id" do
      params do
        requires :id, type: String, desc: "Service ID"
      end

      desc "Service attributes" do
        detail "Team and attributes of a service"
        entity Entities::ServiceEntity
        nickname 'show'
        produces ['application/json']
        consumes ['application/json']
        tags ['services']

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
        service = @user&.business&.services&.find_by!(public_id: params[:id])

        present service, with: Entities::ServiceEntity
      end
    end
  end
end
