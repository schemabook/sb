Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'public#index'

  # TODO: delete, was a prototype
  get 'marketing', to: 'marketing#index'


  ### Marketing pages
  get 'features', to: 'public#features'
  get 'pricing', to: 'public#pricing'
  get 'company', to: 'public#company'
end
