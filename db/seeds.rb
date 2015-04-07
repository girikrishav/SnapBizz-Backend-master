require 'json'
require 'rubygems'
require 'csv'

# pwd  = File.dirname(File.expand_path(__FILE__))

# product_list = []
# companies_brands = {}
# categories = {}
# brands_list = []

# encoding_options = {
#   :invalid           => :replace,  # Replace invalid byte sequences
#   :undef             => :replace,  # Replace anything not defined in ASCII
#   :replace           => '',        # Use a blank for those replacements
#   :universal_newline => true       # Always break lines with \n
# }
# Product.create(name: 'Quick Add Food Item', barcode: 'quickaddfood')
# Product.create(name: 'Quick Add Kitchen Item', barcode: 'quickaddkitchen')
# Product.create(name: 'Quick Add Home Cate Item', barcode: 'quickaddhomecare')
# Product.create(name: 'Quick Add BathRoom Item', barcode: 'quickaddbathroom')
# Product.create(name: 'Quick Add Others', barcode: 'quickaddothers')
# `sed -i '' 's/  / /g' #{pwd}/seed_data/CDB.csv`
# products = CSV.read("#{pwd}/seed_data/CDB.csv", :encoding => 'ISO-8859-1', :headers => true, :header_converters => :symbol)
# products.each do |product|
#   product_list.push(product)

#   category_name = product[:category].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#   sub_category = product[:subcategory].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#   company_name = product[:company].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#   brand_name = product[:brand].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#   cat = Category.find_or_initialize_by(:name => category_name)
#   cat.save!(:validate => false)
#   categories[category_name] = {:id => cat.id, :name => category_name, :parent_id => -1} unless categories[category_name]

#   sub_cat = Category.find_or_initialize_by({:name => sub_category, :parent_id => cat.id})
#   sub_cat.save!(:validate => false)  
#   categories[sub_category] = {:id => sub_cat.id, :name => sub_category, :parent_id => cat.id} unless categories[sub_category]

#   company = Company.find_or_initialize_by({:name => company_name})
#   company.save!(:validate => false)
#   companies_brands[company_name] ||= {:id => company.id, :name => company_name, :brands => []} unless companies_brands[company_name]

#   brand = Brand.find_or_initialize_by({:name => brand_name, :company_id => company.id})
#   brand.save!(:validate => false)

#   companies_brands[company_name][:brands].push(brand_name) unless companies_brands[company_name][:brands].include?(brand_name)

#   brands_list.push(brand_name) unless brands_list.include?(brand_name)

#   prod = Product.find_or_initialize_by({:barcode => product[:barcode]})
#   prod.name = product[:itemname].gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#   prod.mrp  = product[:mrp]
#   prod.brand_id = brand.id
#   prod.category_id = cat.id
#   prod.sub_category_id = sub_cat.id
#   prod.save!(:validate => false)
# end
# `pg_dump --column-inserts --data-only --table=products snapbizz_api_development_mt > #{pwd}/seed_data/products.sql`
# `pg_dump --column-inserts --data-only --table=companies snapbizz_api_development_mt > #{pwd}/seed_data/companies.sql`
# `pg_dump --column-inserts --data-only --table=brands snapbizz_api_development_mt > #{pwd}/seed_data/brands.sql`
# `pg_dump --column-inserts --data-only --table=categories snapbizz_api_development_mt > #{pwd}/seed_data/categories.sql`

# brands_list.uniq!

# File.open("#{pwd}/seed_data/companyjson.txt",'w') do |data|
#   data.puts "{response: ["
#   companies_brands.each do |key, value|
#     data.puts "{companyName:\"#{key}\", id:#{value[:id]}},"
#   end
#   data.puts "]}"
# end

# File.open("#{pwd}/seed_data/brandjson.txt",'w') do |data|
# data.puts "{response: ["
# brands_list.each_with_index do |brand, id|
# data.puts "{brandName:\"#{brand}\", id:#{id+1}},"
# end
# data.puts "]}"
# end

# File.open("#{pwd}/seed_data/companybrandjson.txt",'w') do |data|
#   data.puts "{response: ["
#   companies_brands.each do |company, value|
#     value[:brands].each do |brand|
#       data.puts "{company_id: #{value[:id]}, brand_id: #{brands_list.index(brand)+1}},"
#     end
#   end
#   data.puts "]}"
# end

# File.open("#{pwd}/seed_data/categoryjson.txt",'w') do |data|
#   data.puts "{response: ["
#   categories.each do |name, value|
#     data.puts "{id:#{value[:id]}, categoryName:\"#{value[:name]}\", parentId:#{value[:parent_id]}},"
#   end
#   data.puts "]}"
# end

# File.open("#{pwd}/seed_data/prodjson.txt",'w') do |data|
#   data.puts "{response: ["
#   product_list.each do |product|
#     product_name = product[2].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip
#     sub_category_id = categories[product[4].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip][:id]
#     company_id = companies_brands[product[5].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip][:id]
#     brand_id = brands_list.index(product[6].upcase.gsub(/[^\w-] /, '').gsub("'", '').gsub('"','').encode(Encoding.find('ASCII'), encoding_options).strip)+1
#     data.puts "{barCode:\"#{product[0]}\", mrp:#{product[1]}, productName:\"#{product_name}\", subcategoryId:#{sub_category_id}, companyId:#{company_id.to_i}, brandId:#{brand_id.to_i}, saleprice:0.0},"
#   end
#   data.puts "]}"
# end



base_dir = "#{Rails.root}/db/seed_data"

bulk_load = [Company, Brand, Category, Product, AppUpdate]

bulk_load.each do |table|
  if table.first.nil? # only bulk load into empty tables
    f = File.new "#{base_dir}/#{table.table_name}.sql"

    while statements = f.gets("") do
      puts statements
      ActiveRecord::Base.connection.execute(statements)
    end  
  end
end
ActiveRecord::Base.connection.execute("SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies)+1);")
ActiveRecord::Base.connection.execute("SELECT setval('brands_id_seq', (SELECT MAX(id) FROM brands)+1);")
ActiveRecord::Base.connection.execute("SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories)+1);")
ActiveRecord::Base.connection.execute("SELECT setval('products_id_seq', (SELECT MAX(id) FROM products)+1);")
ActiveRecord::Base.connection.execute("SELECT setval('app_updates_id_seq', (SELECT MAX(id) FROM app_updates)+1);")