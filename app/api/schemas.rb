class Schemas < Grape::API
  format :json
  desc "End-points for schemas"

  namespace :schemas do
    desc "Collection of all of a companies schemas"
    params do
      requires :business, type: String, desc: "business"
      requires :email, type: String, desc: "email"
    end

    get do
      business = Business.find(params[:business])
      user = business.users.find_by(email: params[:email])

      schemas = user.business.schemas.all

      present schemas
    end
  end
end
