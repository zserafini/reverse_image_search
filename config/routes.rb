require 'sidekiq/web'

ReverseImageSearch::Application.routes.draw do

  root 'directories#browse'

  get '/directories/browse', to: 'directories#browse'
  get '/directories/scan', to: 'directories#scan'

  get '/images/find_duplicate', to: 'images#find_duplicate'
  get '/images/inline', to: 'images#inline'
  get '/images/delete_file', to: 'images#delete_file'
  get '/image/', to: 'images#show', as: :custom_image

  mount Sidekiq::Web => '/sidekiq'
end
