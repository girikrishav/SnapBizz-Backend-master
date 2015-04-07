class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :tablet_db_id 
      t.float :amount
      t.belongs_to :distributor
      t.datetime :payment_date 
      t.string :mode_of_payment
      t.string :cheque_number
      t.string :store_id
      t.timestamps
    end
  end
end
