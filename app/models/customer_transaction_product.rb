class CustomerTransactionProduct < ActiveRecord::Base
  belongs_to :customer_transaction
  validates :product_id, presence: {:message => "BarCode is a mandatory Field!"}
  validates :quantity, presence: {:message => "Quantity is Mandatory!"}
  validates :sale_price, presence: {:message => "Sale Price is Mandatory!"}
end
