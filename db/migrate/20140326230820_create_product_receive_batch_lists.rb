class CreateProductReceiveBatchLists < ActiveRecord::Migration
  def change
    create_table :product_receive_batch_lists do |t|
      t.string :barcode, index: true
      t.string :store_id, index: true
      t.integer :quantity
      t.integer :available_quantity
      t.float :mrp
      t.float :purchase_price
      t.float :discount
      t.datetime :date
      t.integer :purchase_order_id, index: true
      t.integer :tablet_db_id, index: true
      t.timestamps
    end
  end
end
