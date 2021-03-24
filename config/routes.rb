Rails.application.routes.draw do
  devise_for :users
  #devise_for :users,
  #  path: 'auth',
  #  path_names: {
  #    sign_in: 'login',
  #    sign_out: 'logout',
  #    password: 'secret',
  #    confirmation: 'verification',
  #    unlock: 'unblock',
  #    registration: 'register',
  #    sign_up: 'cmon_let_me_in'
  #  }

  #resources :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
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

  # signup/sign in routes
  get 'signup', to: 'signup#show'

  ### Application routes
  # TODO: add a redirect to the dashboards page
  get '/users' => 'dashboards#index', as: :user_root # creates user_root_path, used for after sign in path
  get 'dashboards', to: 'dashboards#index'
  get 'schema', to: 'schemas#show'
end
