class CreateDistributorBrands < ActiveRecord::Migration
  def change
    create_table :distributor_brands do |t|
      t.belongs_to :distributor, index: true
      t.belongs_to :brand, index: true
      t.string :store_id, index: true
      t.timestamps
    end
  end
end
