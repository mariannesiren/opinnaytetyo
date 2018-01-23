Rails.application.routes.draw do
  devise_for :users
  resource :home, only: [:show]
  resources :groups
  root to: "homes#show"
end
