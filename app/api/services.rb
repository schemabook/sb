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
  end
end
