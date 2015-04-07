class AddFieldsToCustomerTransactionProducts < ActiveRecord::Migration
  def change
    add_column :customer_transaction_products, :date, :datetime
    add_column :customer_transaction_products, :line_item_total, :float
    add_column :customer_transaction_products, :line_item_profit, :float
    rename_column :customer_transaction_products, :transaction_id, :customer_transaction_id
  end
end
