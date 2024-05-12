# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: {
               registrations: :registrations
             }#, skip: %i[registrations]
  resources :users, only: %i[show index edit]
  get 'my_profile', :to => 'users#my_profile'

  get 'welcome/index'

  root 'welcome#index'
end
