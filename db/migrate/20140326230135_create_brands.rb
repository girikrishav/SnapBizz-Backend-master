class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.belongs_to :company, index: true
      t.string :store_id, index: true
      t.integer :tablet_db_id, index: true
      t.timestamps
    end
  end
end
