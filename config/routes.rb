# frozen_string_literal: true

Rails.application.routes.draw do
  root 'grids#new'
  post '/' => 'grids#create'

  get 'play' => 'grids#play'
end
