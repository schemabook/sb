Rails.application.routes.draw do
  root 'public#index'
  get 'status', to: 'public#status'

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
  get 'users', to: redirect('dashboards'), as: :user_root # creates user_root_path, used for after sign in path
  get 'dashboards', to: 'dashboards#index'
  get 'schema', to: 'schemas#show'

  # profiles (user is the resource)
  get 'profiles/:id/edit', to: 'profiles#edit', as: :edit_user_profile
  get 'profiles/:id', to: 'profiles#show', as: :user_profile
  patch 'profiles/:id', to: 'profiles#update', as: :patch_user_profile

  resources :teams, except: :index
  resources :businesses

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations'
  }
end
