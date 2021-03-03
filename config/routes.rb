Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'public#index'

  # TODO: delete, was a prototype
  get 'marketing', to: 'marketing#index'


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

end
