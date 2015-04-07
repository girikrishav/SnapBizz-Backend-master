class AddBillProductUnitTypeToCustomerTransactionProduct < ActiveRecord::Migration
  def change
    add_column :customer_transaction_products, :bill_product_unit_type, :string
  end
end
