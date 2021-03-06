class Category < ActiveRecord::Base
  has_many :sub_categories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent_category, :class_name => "Category"
  has_many :products
end
