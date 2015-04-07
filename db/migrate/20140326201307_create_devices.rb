class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id, index: true
      t.string :api_key
      t.string :access_token
      t.belongs_to :store, index: true
      t.timestamps :expiry_time
      t.timestamps
    end
  end
end
