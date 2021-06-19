Rails.application.routes.draw do
  ## ORDENES DE COMPRA
  post 'orden_compra/:oc_id', to: 'orden_compra#recibir'
  get 'orden_compra/new'
  get 'orden_compra/index'
  get 'orden_compra/show'
  get 'orden_compra/edit'
  ## STOCKS
  get 'stocks', to: 'stock#index'
  get 'stock/show'
  get 'stock/update'
  get 'stock/delete'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
