Rails.application.routes.draw do

  resources :events
  root 'pages#index'
  get 'pages/show', to: 'pages#show', as: :schdule_show
  #get 'pages/:id/show', to: 'pages#show', as: :schdule_show

  #resources :users

  # ＜ToDoリスト関係＞
  get 'todolist/show', to: 'todolist#show', as: :todolist_show
  get 'todolist/new', to: 'todolist#new', as: :todolist_new
  post 'todolist/create', to: 'todolist#create', as: :todolist_create
  get 'todolist/:id/finish', to: 'todolist#finish', as: :todolist_finish
  get 'todolist/:id/delete', to: 'todolist#delete', as: :todolist_delete

  # ＜目標設定関係＞
  get 'goalset/show', to: 'goalset#show', as: :goalset_show

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
