Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'
  #root "articles#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  


  get 'home/list'

  
end
