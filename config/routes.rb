Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :merchants, only: %i(index show) do
        resources :items, only: %i(index), module: 'merchants'
        get 'find_all', on: :collection, to: 'merchants/find#index'
        get 'find', on: :collection, to: 'merchants/find#show'
      end

      resources :items do
        resources :merchant, only: %i(index), module: 'items'
        get 'find_all', on: :collection, to: 'items/find#index'
        get 'find', on: :collection, to: 'items/find#show'
      end
    end
  end
end
