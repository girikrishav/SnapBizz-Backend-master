class CreateStoreDistributors < ActiveRecord::Migration
  def change
    create_table :store_distributors do |t|
      t.string :store_id, index: true
      t.belongs_to :distributor, index: true
      t.timestamps
    end
  end
end
