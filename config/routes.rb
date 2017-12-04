Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get 'users', to: 'users#show'
  post 'calculation/new', to: 'calculations#create'
  get 'calculation/new', to: 'calculations#new'
  get 'calculations/:calculation_id', to: 'calculations#show'
  get 'calculations', to: 'calculations#all'
  get 'calculations/:calculation_id/edit', to: 'calculations#edit'
  patch 'calculations/:calculation_id/update', to: 'calculations#update'
  delete 'calculations/:calculation_id', to: 'calculations#delete'
end
