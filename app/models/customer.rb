class Customer < ActiveRecord::Base
  has_many :customer_transactions
  validates :tablet_db_id, presence: :true, numericality: true, uniqueness: { scope: :store_id }
  validates :phone, presence: true, numericality: true
end
