Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get 'new', to: 'welcome#new'
  get 'users', to: 'users#show'
  post 'calculation/new', to: 'calculations#create'
  get 'calculation/new', to: 'calculations#new'
  get 'calculations/:calculation_id', to: 'calculations#show'
  get 'calculations', to: 'calculations#all'
end
