class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :barcode, index: true
      t.float :mrp
      t.float :base_quantity
      t.string :unit_type
      t.string :store_id, index: true
      t.belongs_to :brand, index: true
      t.belongs_to :category, index: true
      t.timestamps
    end
  end
end