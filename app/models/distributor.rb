class Distributor < ActiveRecord::Base
  validates_presence_of :agency_name
  validates :tablet_db_id, presence: true, uniqueness: { scope: :store_id }
  scope :store_distributors, ->(store_id) { where(store_id => Digest::MD5::hexdigest(store_id)) }
end
