class CustomerTransaction < ActiveRecord::Base
  # belongs_to :customer
  validates :store_id, presence: true
  # validates :customer, presence: true
  has_many :customer_transaction_products, dependent: :destroy, validate: false
  
  validates :date, :payment_mode, :status, presence: true
  validates :status, inclusion: {in: %w{paid delivery}}
  validates :payment_mode, inclusion: {in: %w{cash credit card coupon}}
  
  validates :tablet_db_id, presence: :true, numericality: true, uniqueness: { scope: :store_id }

  # validates :customer_transaction_products, presence: true
end
