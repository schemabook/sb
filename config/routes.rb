Rails.application.routes.draw do
  resources :businesses
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  root 'public#index'

  ### Marketing pages
  get 'features', to: 'public#features'
    get 'features/producers', to: 'public#producers'
    get 'features/consumers', to: 'public#consumers'
    get 'features/api_admins', to: 'public#api_admins'
    get 'features/database_admins', to: 'public#database_admins'
  get 'pricing', to: 'public#pricing'
  get 'company', to: 'public#company'
    get 'about', to: 'public#company'

  get 'docs', to: 'public#docs'
  get 'guides', to: 'public#guides'
  get 'status' => redirect("http://twitter.com/schemabook_status")

  get 'blog' => redirect("http://medium.com/schemabook")

  get 'privacy', to: 'public#privacy'
  get 'terms', to: 'public#terms'

  ### Application routes
  # TODO: add a redirect to the dashboards page
  get 'users', to: redirect('dashboards'), as: :user_root # creates user_root_path, used for after sign in path
  get 'dashboards', to: 'dashboards#index'
  get 'schema', to: 'schemas#show'
end
