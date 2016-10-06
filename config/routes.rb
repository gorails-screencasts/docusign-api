Rails.application.routes.draw do
  namespace :docusign do
    resources :webhooks, only: [:create]
  end
end
