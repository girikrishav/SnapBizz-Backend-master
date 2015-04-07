require 'rubygems'
require 'csv'
require 'timeout'
require 'json'
require 'binged'
require "google_drive"
session = GoogleDrive.login("kannan@cognitiveclouds.com","")
ws = session.spreadsheet_by_key("0Aju4R13ypyHkdFNPcU15TWt6alNNTnBDTnIyQTJSb1E").worksheets[0]
company_id = 1
brand_id = 1
category_id = 1
sub_category_id = 1

product_list = []
companies_brands = {}
categories = {}
brands_list = []

ws.rows[1..-1].each do |product|
	product_list.push(product)
	category_name = product[3].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')
	sub_category = product[4].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')
	company_name = product[5].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')
	brand_name = product[6].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')

	unless categories[category_name]
		categories[category_name] = {:id => category_id, :name => category_name, :parent_id => -1} 
		category_id = category_id + 1
	end
	unless categories[sub_category]
		categories[sub_category] = {:id => category_id, :name => sub_category, :parent_id => categories[category_name][:id]} 
		category_id = category_id + 1
	end
	unless companies_brands[company_name]
		companies_brands[company_name] ||= {:id => company_id, :name => company_name, :brands => []}
		company_id = company_id + 1
	end
	companies_brands[company_name][:brands].push(brand_name) unless companies_brands[company_name][:brands].include?(brand_name)
	brands_list.push(brand_name) unless brands_list.include?(brand_name)
end

brands_list.uniq!
pwd  = File.dirname(File.expand_path(__FILE__))

File.open("#{pwd}/company.json",'w') do |data|
	data.puts "{response: ["
	companies_brands.each do |key, value|
		data.puts "{companyName:\"#{key}\", id:#{value[:id]}},"
	end
	data.puts "]}"
end

File.open("#{pwd}/brand.json",'w') do |data|
data.puts "{response: ["
brands_list.each_with_index do |brand, id|
data.puts "{brandName:\"#{brand}\", id:#{id+1}},"
end
data.puts "]}"
end

File.open("#{pwd}/companies_brands.json",'w') do |data|
	data.puts "{response: ["
	companies_brands.each do |company, value|
		value[:brands].each do |brand|
			data.puts "{company_id: #{value[:id]}, brand_id: #{brands_list.index(brand)+1}},"
		end
	end
	data.puts "]}"
end

File.open("#{pwd}/category.json",'w') do |data|
	data.puts "{response: ["
	categories.each do |name, value|
		data.puts "{id:#{value[:id]}, categoryName:\"#{value[:name]}\", parentId:#{value[:parent_id]}},"
	end
	data.puts "]}"
end

File.open("#{pwd}/products.json",'w') do |data|
data.puts "{response: ["
product_list.each do |product|
product_name = product[2].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')
sub_category_id = categories[product[4].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')][:id]
company_id = companies_brands[product[5].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' ')][:id]
brand_id = brands_list.index(product[6].upcase.gsub(/[^\w-] /, ' ').gsub("'", ' ').gsub('"',' '))+1
data.puts "{barCode:\"#{product[0]}\", mrp:#{product[1]}, productName:\"#{product_name}\", subcategoryId:#{sub_category_id}, companyId:#{company_id.to_i}, brandId:#{brand_id.to_i}, saleprice:0.0},"
end
data.puts "]}"
end



# File.open('products.json', 'w') do |data|  
# data.puts "{response: ["
# products.each do |product|
# barcode = product[:barcode].gsub('M-','')
# productname = product[:name].gsub(/[^\w-] /, '').gsub("'", '').gsub('"','')
# mrp = product[:mrp]
# sub_category_id = categoriy_list.index(product[:subcategory])+1
# company_id = companies_brands[brand_company[product[:brand]]][:id] rescue nil
# brand_id = brands_list.index(product[:brand])+1 if brands_list.index(product[:brand]) rescue nil
# sale_price = product[:saleprice]
# data.puts "{barCode:\"#{barcode}\", productName:\"#{productname}\", mrp:#{mrp.to_i}, subcategoryId:#{sub_category_id}, companyId:#{company_id.to_i}, brandId:#{brand_id.to_i}, saleprice:#{sale_price.to_i}},"
# data.puts "]}"
# end

# ds_list.push (brandname)
# d_company[brandname] = "SnapBizz"
# ies_brands["SnapBizz"][:brands].push(brandname) 
# d
# "{brandName:\"#{brand}\", id:#{id+1}},"
# File.open('brand.json', 'w') do |data|  
# companies_brands["SnapBizz"] = {:id => company_id, :brands => []}
# brandname = product[:brand].downcase
# unless brands_list.include?(brandname)
# brands_list.push (brandname)
# brand_company[brandname] = "SnapBizz"
# companies_brands["SnapBizz"][:brands].push(brandname) 
# brands_list.each_with_index do |brand, id|
# data.puts "{brandName:\"#{brand}\", id:#{id+1}},"
# File.open('company.json', 'w') do |data|
# companies_brands.each do |key, value|
# data.puts "{companyName:\"#{key}\", id:#{value[:id]}},"
# File.open('company_brand.json', 'w') do |data| 
# companies_brands.each do |company, value|
# value[:brands].each do |brand|
# data.puts "{company_id:#{value[:id]}, brand_id:#{brands_list.index(brand)+1}},"
# categories = {}
# categoriy_list = []
# category_id = 1
# File.open('category.json', 'w') do |data| 
# data.puts "{response: [" 
# for i in 0..(products.size-1)
# product = products[i]
# categoryname = product[:category]
# sub_category = product[:subcategory]
# categoriy_list.push(categoryname) unless categoriy_list.include?(categoryname)
# categoriy_list.push(sub_category) unless categoriy_list.include?(sub_category)
# unless categories[categoryname]
# categories[categoryname] = {:id => category_id, :sub_category => []}
# category_id = category_id + 1
# categories[categoryname][:sub_category].push(sub_category) unless categories[categoryname][:sub_category].include?(sub_category)
# categories.each do |category, value|
# data.puts "{id: #{categoriy_list.index(category)+1}, categoryName: \"#{category}\", parentId: -1},"
# value[:sub_category].each do |sub_category|
# data.puts "{id: #{categoriy_list.index(sub_category)+1}, categoryName: \"#{sub_category}\", parentId: #{categoriy_list.index(category)+1}},"

# Dir.glob("DualScreen-Billing/*.jpg").each { |filename| File.rename(filename, "Dualscreen_Billing_#{filename.gsub(/[^\w-]/, '')}")}
# Dir.glob("*.jpg").each { |filename| File.rename(filename, "Dualscreen_Billing_#{filename.gsub(/[^\w-]/, '')}")}
# Dir.glob("*.jpg").each { |filename| File.rename(filename, "Dualscreen_Billing_#{filename}")}
# Dir.glob("*.jpg").each { |filename| File.rename(filename, "SplitScreen_Billing_#{filename}")}
# Dir.glob("*.jpg").each { |filename| File.rename(filename, "Stock_#{filename}")}

