class AddToProductIdToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :product_id, :integer
  end
end
