Rails.application.routes.draw do

  root "posts#index"

  get "sign-up", to: "registrations#new"
  post "sign-up", to: "registrations#create"
  get "sign-in", to: "authentication#new"
  post "sign-in", to: "authentication#create"
  get "sign-out", to: "authentication#destroy"

  resources :users, only: [] do
    resources :posts, only: [:new]
  end

  resources :posts, only: [:index, :show]

  resources :posts  do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end
end
