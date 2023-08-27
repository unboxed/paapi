# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  mount Rswag::Ui::Engine => "/api-docs"

  devise_for :users

  resources :csv_uploads
  get :healthcheck, to: proc { [200, {}, %w[OK]] }

  namespace :api do
    namespace :v1 do
      resources :planning_applications, only: %i[index create]
    end
  end
end
