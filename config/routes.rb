require 'sidekiq/web'

ReverseImageSearch::Application.routes.draw do

  get '/directories/browse', to: 'directories#browse'
  get '/directories/scan', to: 'directories#scan'

  get '/images/find_duplicate', to: 'images#find_duplicate'
  get '/image/' => 'images#show', :as => :custom_image

  mount Sidekiq::Web => '/sidekiq'
end
