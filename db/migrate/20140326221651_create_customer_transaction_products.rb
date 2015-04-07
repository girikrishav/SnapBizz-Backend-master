class CreateCustomerTransactionProducts < ActiveRecord::Migration
  def change
    create_table :customer_transaction_products do |t|
      t.string :store_id, index: true
      t.integer :quantity
      t.float :sale_price
      t.belongs_to :transaction, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
