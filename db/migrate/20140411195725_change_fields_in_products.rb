class ChangeFieldsInProducts < ActiveRecord::Migration
  def change
    rename_column :products, :category_id, :sub_category_id
    add_column :products, :category_id, :integer
  end
end
