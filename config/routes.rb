Rails.application.routes.draw do

  resources :events
  root 'pages#index'
  # root 'users/sessions#new'
  
  # ＜LINE処理関係＞
  post '/callback' => 'linebot#callback'
  # get '/callback' => 'linebot#callback'
  get '/relation' => 'linebot#relation', as: :line_relation
  get '/relateback' => 'linebot#relateback', as: :line_relateback
  patch '/push' => 'linebot#line_test', as: :line_send_message
  # post '/push' => 'linebot#line_test', as: :line_send_message
  get '/setnotice' => 'linebot#setnotice', as: :line_setnotice

  # ＜スケジュール関係＞
  #get 'pages/:id/show', to: 'pages#show', as: :schdule_show
  get 'pages/show', to: 'pages#show', as: :schdule_show
  get 'pages/all_event_list_class', to: 'pages#all_event_list_class', as: :all_event_list_class

  #resources :users

  # ＜ToDoリスト関係＞
  get 'todolist/show', to: 'todolist#show', as: :todolist_show
  get 'todolist/new', to: 'todolist#new', as: :todolist_new
  post 'todolist/create', to: 'todolist#create', as: :todolist_create
  get 'todolist/:id/finish', to: 'todolist#finish', as: :todolist_finish
  get 'todolist/:id/edit', to: 'todolist#edit', as: :todolist_edit
  get 'todolist/:id/delete', to: 'todolist#delete', as: :todolist_delete

  # ＜目標設定関係＞
  get 'goalset/show', to: 'goalset#show', as: :goalset_show
  get 'goalset/edit', to: 'goalset#edit', as: :goalset_edit
  patch 'goalset/update', to: 'goalset#update', as: :goalset
  post 'goalset/create', to: 'goalset#create', as: :goalsets
  
  # ＜メモ帳＞
  get 'memopad/show', to: 'memopad#show', as: :memopad_show
  get 'memopad/new', to: 'memopad#new', as: :memopad_new
  post 'memopad/create', to: 'memopad#create', as: :memopad_create
  post 'memopad/delete', to: 'memopad#delete', as: :memopad_delete

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
