class CreateDistributorProducts < ActiveRecord::Migration
  def change
    create_table :distributor_products do |t|
      t.belongs_to :distributor, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
