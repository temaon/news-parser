require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'
  get 'categories/:id(/page/:page)', as: :category, to: 'categories#show'
  get 'contact/', as: :api_contact, to: 'api#contact'
  # resources :categories
  resources :news, as: :post

  devise_for :users, as: :frontend


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  authenticate :frontend_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
  mount Commontator::Engine => '/commontator'
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', as: :rails_admin
end
