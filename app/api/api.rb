module API
  class Root < Grape::API
    prefix "api"
    default_format :json
    default_error_formatter :json
    content_type :json, "application/json"

    helpers do
      # clients will pass the header all lowercase (e.g. x-api-token), Rails capitalizes it
      def authenticate
        unauthorized! unless request.headers["X-Api-Token"]

        token = request.headers["X-Api-Token"]
        @user = User.find_by(api_token: token)

        unauthorized! unless @user
      end

      def unauthorized!
        status 401
      end
    end

    before do
      authenticate
    end

    mount Schemas
  end
end
