class Authentication < ActiveRecord::Base
  belongs_to :device
  validates :device, presence: true
  validates :access_token, presence: true, uniqueness: true, length: { is: 64 }

  def generate_access_token
    self.access_token = SecureRandom.hex(32)
    self.save
  end

  def expiry
    return 0 unless self.persisted?
    self.updated_at.advance(days: 7).to_i
  end

  def valid_access_token?(token)
    access_token == token && !expired?
  end

  def expired?
    Time.now.to_i > expiry
  end
end