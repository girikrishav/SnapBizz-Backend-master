class CreateAppUpdates < ActiveRecord::Migration
  def change
    create_table :app_updates do |t|
      t.float :version_number
      t.string :appname
      t.string :path
      t.timestamps
    end
  end
end
