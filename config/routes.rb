Rails.application.routes.draw do
  get 'stocks', to: 'stock#index'
  get 'stock/show'
  get 'stock/update'
  get 'stock/delete'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
