# frozen_string_literal: true

Rails.application.routes.draw do
  scope "/weather" do
    # resources :summary, only: [:get]
    get "summary" => "summary#get"
  end
end
