Rails.application.routes.draw do
  get :healthcheck, to: proc { [200, {}, %w[OK]] }

  namespace :api do
    namespace :v1 do
      resources :planning_applications, only: %i[index]
    end
  end
end
