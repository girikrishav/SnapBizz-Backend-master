class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :agency_name, index: true
      t.string :salesman_name
      t.string :phone
      t.string :tin
      t.string :address1
      t.string :address2
      t.string :city, index: true
      t.string :state, index: true
      t.string :zip, index: true
      t.string :store_id, index: true
      t.integer :tablet_db_id
      t.timestamps
    end
  end
end
