# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/index'

  root 'welcome#index'
end
