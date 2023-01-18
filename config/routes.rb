# frozen_string_literal: true

Rails.application.routes.draw do
  root 'grids#new'

  post '/play' => 'grids#create'
end
