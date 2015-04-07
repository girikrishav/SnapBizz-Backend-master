class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :store_id, index: true
      t.string :barcode, index: true
      t.float :mrp
      t.integer :in_stock_quantity
      t.float :purchase_price
      t.float :sale_price
      t.float :tax_rate
      t.string :unit_type
      t.string :tag
      t.timestamps
    end
  end
end
