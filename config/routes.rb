Rails.application.routes.draw do
  resources :articles
  resources :questions
  resources :answers

  root 'articles#index'
end
