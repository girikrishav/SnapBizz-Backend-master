class Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :category
  # validates :name, presence: :true, uniqueness: { scope: :store_id }
  validates :barcode, presence: :true, uniqueness: { scope: :store_id }
end
