Rails.application.routes.draw do

  root 'pages#index'
  get 'pages/show', as: :schdule_show

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
