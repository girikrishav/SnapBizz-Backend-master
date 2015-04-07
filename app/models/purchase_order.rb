class PurchaseOrder < ActiveRecord::Base
  belongs_to :distributor
  validates :tablet_db_id, presence: :true, numericality: true, uniqueness: { scope: :store_id }
  validates :store_id, :distributor, :date, presence: true
end
