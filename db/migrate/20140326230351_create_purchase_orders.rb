class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.belongs_to :distributor, index: true
      t.string :store_id, index: true
      t.integer :tablet_db_id
      t.float :bill_amount
      t.string :status
      t.date :date
      t.timestamps
    end
  end
end
