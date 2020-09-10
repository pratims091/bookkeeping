# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :authentications do
        post :login
      end
      resources :users, only: %i[create]
      resources :contacts, only: %i[index create]
      resources :transactions, only: %i[index create]
    end
  end
end
