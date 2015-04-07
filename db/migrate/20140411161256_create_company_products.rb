class CreateCompanyProducts < ActiveRecord::Migration
  def change
    create_table :company_products do |t|
      t.belongs_to :company
      t.belongs_to :product
      t.timestamps
    end
  end
end
