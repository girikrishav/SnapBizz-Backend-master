class AddIsOfferToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :is_offer, :boolean
  end
end
