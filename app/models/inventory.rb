class Inventory < ActiveRecord::Base
  validates :barcode, presence: {:message => "Product ID is a mandatory Field!"}
  validates :store_id, presence: {:message => "Store ID is Mandatory!"}
  validates :in_stock_quantity, presence: {:message => "Without Quantity - Inventory means nothing!"}
  # scope :distributor_all_stock_value, lambda{ |distributor_id, store_id| where(:distributor_id => distributor_id, :store_id => Digest::MD5::hexdigest(store_id)) }
end