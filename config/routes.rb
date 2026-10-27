Rails.application.routes.draw do
  root "games#index"
  resources :games do
    get :delete, on: :member
  end
end
