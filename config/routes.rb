Rails.application.routes.draw do

  root "posts#index"

  get "sign-up", to: "registrations#new"
  post "sign-up", to: "registrations#create"
  get "sign-in", to: "authentication#new"
  post "sign-in", to: "authentication#create"
  get "sign-out", to: "authentication#destroy"

  resources :users do
    resources :posts
  end

  resources :posts, only: [:index, :show]

  resources :posts  do
    resources :comments, only: [:new, :create]
  end
end
