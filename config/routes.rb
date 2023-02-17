# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"

  get :healthcheck, to: proc { [200, {}, %w[OK]] }

  namespace :api do
    namespace :v1 do
      resources :planning_applications, only: %i[index create]
    end
  end

  root to: "home#index"
end
