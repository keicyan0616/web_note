Rails.application.routes.draw do

  resources :events
  root 'pages#index'
  get 'pages/show', to: 'pages#show', as: :schdule_show
  #get 'pages/:id/show', to: 'pages#show', as: :schdule_show

  #resources :users

  devise_for :users, :controllers => {
    :omniauth_callbacks => "omniauth_callbacks",
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  } 
  
  devise_scope :user do
    get "user/:id", :to => "users/registrations#detail"
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end

end
