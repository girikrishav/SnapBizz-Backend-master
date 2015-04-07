require 'rubygems'
require 'csv'
require 'json'
require 'fuzzy_match'
require 'amatch'
include Amatch

def msg2str(msg)
  case msg
  when ::String
    msg
  when ::Exception
    "#{msg.message} (#{msg.class}), backtrace: " << (msg.backtrace || []).to_json
  else
    msg.inspect
  end
end

products = CSV.read("database.csv", {:headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1'} )
brands = CSV.read("brands.csv", {:headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1'} )
categories = CSV.read("categories.csv", {:headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1'} )

brand_names = brands.collect {|brand| brand[1].downcase}
category_names = categories.collect {|category| category[1].downcase}


cleaned_products = []
for i in 0..9999
# products[0..99].each do |product|

  product = products[i]
  # puts product[:itemname]
  # puts product.inspect
	product = Jaro.new(product[:itemname])
	arr=product.match(brand_names)
	product[:brand_name] = brand_names[arr.rindex(arr.max)]

  # cat_match = Jaro.new(product[:itemname])
  arr=product.match(category_names)
  product[:sub_category] = category_names[arr.rindex(arr.max)]
  cleaned_products << [product[:barcode], product[:itemname], product[:mrp], product[:brand_name], product[:sub_category]]
end
# headers= cleaned_products[0]

CSV.open("data.csv", "wb") do |csv|
  cleaned_products.each do |product|
    csv << product
    # product.to_a.each {|elem| csv << elem} 
  end
end


# Fuzzy Match
fz = FuzzyMatch.new(brand_names)
fz.find(pname)
cz=FuzzyMatch.new(category_names)
cz.find(pname)