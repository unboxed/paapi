Rails.application.routes.draw do
  get :healthcheck, to: proc { [200, {}, %w[OK]] }
end
