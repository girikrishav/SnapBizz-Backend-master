class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :tin
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state, index: true
      t.string :zip, index: true
      t.belongs_to :retailer, index: true

      t.timestamps
    end
  end
end
