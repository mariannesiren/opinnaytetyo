Rails.application.routes.draw do
  devise_for :users
  resource :home, only: [:show]
  resources :groups do
    resources :group_attachments, only: [], path: "attachements" do
      get "/download", to: "group_attachements#download"
    end
  end
  root to: "homes#show"
  mount Shrine.presign_endpoint(:cache) => "/presign"
end
