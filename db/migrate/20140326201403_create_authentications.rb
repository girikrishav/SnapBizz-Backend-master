class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :access_token
      t.belongs_to :device, index: true

      t.timestamps
    end
  end
end
