class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :store_id, index: true
      t.integer :tablet_db_id
      t.timestamps
    end
  end
end
