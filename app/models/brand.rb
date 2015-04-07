class Brand < ActiveRecord::Base
  belongs_to :company
  has_many :products
  # validates :tablet_db_id, numericality: true, uniqueness: { scope: :store_id }#, presence: :true,
end
