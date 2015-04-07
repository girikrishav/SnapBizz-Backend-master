class CreateStoreBackups < ActiveRecord::Migration
  def change
    create_table :store_backups do |t|
      t.string :store_id
      t.string :table
      t.json :raw_data
      t.datetime :sync_date
      t.timestamps
    end
  end
end
