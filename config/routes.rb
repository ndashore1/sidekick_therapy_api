# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api do
    namespace :v1 do
      resources :users, only: %i[index create] do
        resources :patient_histories, only: :create
      end

      resources :sessions, only: :create do
        delete :sign_out, on: :collection
      end

      resources :plan_of_cares do
        resources :goals
      end
    end
  end
end
