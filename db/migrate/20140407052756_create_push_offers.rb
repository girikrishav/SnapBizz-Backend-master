class CreatePushOffers < ActiveRecord::Migration
  def change
    create_table :push_offers do |t|
      t.string :store_id, index: :true
      t.string :purchase_type #Price, Category, Product
      t.string :offer_type #percentage, amount
      t.string :offer_value #store only offer_value incase of flat storewide offer
      t.datetime :start_date
      t.datetime :end_date
      t.string :message      
      t.timestamps
    end
  end
end
