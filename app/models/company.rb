class Company < ActiveRecord::Base
  has_many :brands
  # validates :tablet_db_id, numericality: true, uniqueness: { scope: :store_id }#, presence: :true,
end
