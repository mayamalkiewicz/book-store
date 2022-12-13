Rails.application.routes.draw do
  root 'home#index'
  #root "articles#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  #get "/articles", to: "articles#index"
  #get "/articles/:id", to: "articles#show"
  #get "articles/about"

  get 'home/list'

  # Defines the root path route ("/")
  # root "articles#index"
end
