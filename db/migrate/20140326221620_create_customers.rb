class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city, index: true
      t.string :state, index: true
      t.string :zip, index: true
      t.string :store_id, index: true
      t.integer :tablet_db_id, index: true
      t.timestamps
    end
  end
end
