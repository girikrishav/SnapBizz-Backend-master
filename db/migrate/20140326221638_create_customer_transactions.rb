class CreateCustomerTransactions < ActiveRecord::Migration
  def change
    create_table :customer_transactions do |t|
      t.datetime :date
      t.string :store_id, index: true
      t.belongs_to :customer, index: true
      t.float :discount, default: 0.0
      t.float :total_amount, default: 0
      t.string :payment_mode, default: 'cash'
      t.string :status, default: 'paid'
      t.integer :tablet_db_id, index: true
      t.timestamps
    end
  end
end
