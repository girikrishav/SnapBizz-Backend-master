class CreatePurchaseOrderProducts < ActiveRecord::Migration
  def change
    create_table :purchase_order_products do |t|
      t.belongs_to :purchase_order, index: true
      t.belongs_to :product, index: true
      t.string :store_id, index: true
      t.integer :quantity
      t.timestamps
    end
  end
end