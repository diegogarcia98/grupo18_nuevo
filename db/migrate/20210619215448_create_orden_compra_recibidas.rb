class CreateOrdenCompraRecibidas < ActiveRecord::Migration[6.1]
  def change
    create_table :orden_compra_recibidas do |t|
      t.string :oc_id
      t.string, :cliente
      t.bigint :sku
      t.bigint :fechaEntrega
      t.int :cantidad
      t.string :urlNotificacion
      t.string :estado
      t.bigint :creacion
      t.boolean :en_despacho

      t.timestamps
    end
  end
end
