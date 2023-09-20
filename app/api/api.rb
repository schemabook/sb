module API
  class Root < Grape::API
    prefix "api"
    default_format :json

    mount Schemas
  end
end
