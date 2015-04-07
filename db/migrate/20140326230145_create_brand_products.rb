class CreateBrandProducts < ActiveRecord::Migration
  def change
    create_table :brand_products do |t|
      t.belongs_to :brand, index: true
      t.belongs_to :product, index: true
      t.timestamps
    end
  end
end
