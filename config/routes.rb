Rails.application.routes.draw do
  devise_for :users
  resource :home, only: [:show]
  root to: "homes#show"
end
