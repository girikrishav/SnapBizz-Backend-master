class ProductReceiveBatch < ActiveRecord::Base
  validates :tablet_db_id, presence: :true, numericality: true, uniqueness: { scope: :store_id }
end
