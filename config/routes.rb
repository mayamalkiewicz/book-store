# frozen_string_literal: true

Rails.application.routes.draw do
  resources :books do
    resources :comments, only: %i[create update edit destroy]
  end

  resources :users
  resource :sessions, only: %i[login create destroy]
  resource :users_books, only: %i[create destroy]
  root 'home#startpage'

  # Defines the root path route ("/")
  get 'home/list'
  get 'sessions/login'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
