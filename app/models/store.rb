class Store < ActiveRecord::Base
  has_one :device, dependent: :destroy, validate: false
  belongs_to :retailer

  validates :tin, :name, :address1, :zip, presence: true
  validates :tin, uniqueness: { scope: :address1 }
  validates :device, presence: true
  validate :device_invalid

  accepts_nested_attributes_for :device

  private
  def device_invalid
    if device 
      unless device.valid?
        errors.add("device", device.errors.messages)
      end
    end
  end
end