require 'sidekiq/web'

ReverseImageSearch::Application.routes.draw do
  resources :directories do
    get 'browse', on: :collection
    get 'scan', on: :collection
  end

  resources :images

  mount Sidekiq::Web => '/sidekiq'
end
