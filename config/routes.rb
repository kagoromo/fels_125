Rails.application.routes.draw do
  root "static_pages#home"
  get "help" => "static_pages#help"
  get "about" => "static_pages#about"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :users, except: [:destroy]
  resources :relationships, only: [:create, :destroy]
  resources :categories, only: [:index] do
    resources :lessons, except: [:destroy, :index]
  end
  resources :words, only: [:index]

  namespace :admin do
    resources :categories
    resources :words, except: [:index, :new, :show]
    resources :users, only: [:index, :destroy]
  end

  resources :users do
    resources :relationships, only: [:index]
  end
end
