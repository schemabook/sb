Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  ### API routes
  mount API::Root => "/"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    invitations: "users/invitations"
  }

  root "public#index"

  ### Marketing pages
  get "features", to: "public#features"
  get "features/producers", to: "public#producers"
  get "features/consumers", to: "public#consumers"
  get "features/api_admins", to: "public#api_admins"
  get "features/database_admins", to: "public#database_admins"
  get "pricing", to: "public#pricing"
  get "company", to: "public#company"
  get "about", to: "public#company"

  get "docs", to: "public#docs"
  get "status", to: "public#status"

  get "blog", to: "blog#index"
  get "blog/:id", to: "blog#show"
  # get "blog" => redirect("http://medium.com/schemabook")

  get "privacy", to: "public#privacy"
  get "terms", to: "public#terms"

  post "newsletters", to: "newsletters#create"
  get "newsletters", to: "newsletters#update"

  ### Application routes
  get "users", to: redirect("dashboards"), as: :user_root # creates user_root_path, used for after sign in path
  get "dashboards", to: "dashboards#index"
  get "documents", to: "documents#index"
  get "supports", to: "supports#index"

  # profiles (user is the resource)
  get "profiles/:id/edit", to: "profiles#edit", as: :edit_user_profile
  get "profiles/:id", to: "profiles#show", as: :user_profile
  patch "profiles/:id", to: "profiles#update", as: :patch_user_profile

  # stakeholders
  post "stakeholders", to: "stakeholders#create"

  # favorites
  post "favorites", to: "favorites#create"
  delete "favorites", to: "favorites#destroy"

  resources :teams, except: :index
  resources :businesses
  resources :services
  resources :schemas, param: :public_id do
    resources :validations, only: :create
    resources :webhooks
    resources :versions do
      resources :comments
    end
  end

  get "checkouts", to: "checkouts#new"
  post "checkouts", to: "checkouts#create"
  get "checkouts/success", to: "checkouts#success"
  get "checkouts/cancel", to: "checkouts#cancel"
  delete "checkouts/delete", to: "checkouts#delete"
end
