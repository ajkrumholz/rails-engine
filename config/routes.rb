Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :merchants, only: %i(index show) do
        resources :items, only: %i(index), module: 'merchants'
        get 'find_all', on: :collection, to: 'merchants/find#index'
        get 'find', on: :collection, to: 'merchants/find#show'
      end

      # resource :find, only: :show, module: 'merchants'

      # namespace :merchants do
      #   resource :find, only: %i(index)
      # end

      # get '/merchants/find', to: 'find#show', module: "merchants"
      # get 'merchants/find_all', to: 'merchants/find#index'
      # get 'items/find', to: 'items/find#show'
      # get 'items/find_all', to: 'items/find#index'
      resources :items do
        resources :merchant, only: %i(index), module: 'items'
        get 'find_all', on: :collection, to: 'items/find#index'
        get 'find', on: :collection, to: 'items/find#show'
      end

    end
  end
end
