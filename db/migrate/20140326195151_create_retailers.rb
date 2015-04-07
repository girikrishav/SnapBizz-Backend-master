class CreateRetailers < ActiveRecord::Migration
  def change
    create_table :retailers do |t|
      t.string :name
      t.string :phone, index: true
      t.string :email

      t.timestamps
    end
  end
end
