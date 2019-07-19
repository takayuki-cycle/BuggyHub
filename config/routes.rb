Rails.application.routes.draw do
  get "maps/index" => "maps#index"
  get "maps/new" => "maps#new"
  get "maps/:id" => "maps#show"
  post "maps/create" => "maps#create"
  get "maps/:id/edit" => "maps#edit"
  post "maps/:id/update" => "maps#update"
  post "maps/:id/destroy" => "maps#destroy"
  post "maps/:id/reserve" => "maps#reserve"

  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"

  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  post "login" => "users#login"
  post "guest" => "users#guest"
  post "logout" => "users#logout"
  get "login" => "users#login_form"
  get "users/:id/likes" => "users#likes"
  get "users/:id/maps-no-reserve" => "users#maps_no_reserve"
  get "users/:id/maps-be-reserved" => "users#maps_be_reserved"
  get "users/:id/maps-reserved" => "users#maps_reserved"
  post "users/:id/destroy" => "users#destroy"

  get "posts/index" => "posts#index"
  get "posts/new" => "posts#new"
  get "posts/:id" => "posts#show"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"

  get "/" => "home#top"
  get "about" => "home#about"
  get "self-intro" => "home#self_intro"
end

=begin
  get : データベースを変更しない場合
  post : データベースを変更する場合、sessionの値を変更する場合
=end
