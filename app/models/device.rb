class Device < ActiveRecord::Base
  belongs_to :store
  has_one :authentication

  validates :device_id, presence: true#, uniqueness: true
  validates :api_key, presence: true, uniqueness: true

  before_validation { self.api_key = SecureRandom.hex(16) if self.api_key.nil? }

  def authenticated?(token)
    if authentication
      authentication.valid_access_token?(token)
    else
      false
    end
  end
end
