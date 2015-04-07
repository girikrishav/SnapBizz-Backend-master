class Retailer < ActiveRecord::Base
  has_one :store, dependent: :destroy, validate: false
  validates :name, :phone, presence: true
  validates :phone, uniqueness: true
  
  validates :store, presence: true
  validate :store_invalid
  accepts_nested_attributes_for :store

  private
  def store_invalid
    if store
      unless store.valid?
        errors.add("store", store.errors.messages)
      end
    end
  end
end