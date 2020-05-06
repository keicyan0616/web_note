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
  patch '/noticeupdate' => 'linebot#noticeupdate', as: :notice_update
  patch '/timingupdate' => 'linebot#timingupdate', as: :timing_update

  # ＜ユーザー一覧関係＞
  get 'pages/editusers', to: 'pages#editusers', as: :users_show
  get 'pages/:id/editprofile', to: 'pages#editprofile', as: :profile_show
  patch 'pages/update', to: 'pages#update', as: :profile_update
  delete 'pages/:id/destroy', to: 'pages#destroy', as: :users_delete

  # ＜スケジュール関係＞
  #get 'pages/:id/show', to: 'pages#show', as: :schdule_show
  get 'pages/show', to: 'pages#show', as: :schdule_show
  get 'pages/all_event_list_class', to: 'pages#all_event_list_class', as: :all_event_list_class

  #resources :users

  # ＜ToDoリスト関係＞
  get 'todolist/show', to: 'todolist#show', as: :todolist_show
  get 'todolist/new', to: 'todolist#new', as: :todolist_new
  post 'todolist/create', to: 'todolist#create', as: :todolist_create
  patch 'todolist/update', to: 'todolist#update', as: :todolist_update
  get 'todolist/:id/finish', to: 'todolist#finish', as: :todolist_finish
  get 'todolist/:id/edit', to: 'todolist#edit', as: :todolist_edit
  get 'todolist/:id/delete', to: 'todolist#delete', as: :todolist_delete

  # ＜目標設定関係＞
  get 'goalset/show', to: 'goalset#show', as: :goalset_show
  get 'goalset/editm', to: 'goalset#editm', as: :goalset_editm
  get 'goalset/editg', to: 'goalset#editg', as: :goalset_editg
  patch 'goalset/update', to: 'goalset#update', as: :goalset
  post 'goalset/create', to: 'goalset#create', as: :goalsets
  
  # ＜メモ帳＞
  get 'memopad/show', to: 'memopad#show', as: :memopad_show
  get 'memopad/new', to: 'memopad#new', as: :memopad_new
  get 'memopad/edit', to: 'memopad#edit', as: :memopad_edit
  post 'memopad/create', to: 'memopad#create', as: :memopad_create
  patch 'memopad/update', to: 'memopad#update', as: :memopad_update
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
