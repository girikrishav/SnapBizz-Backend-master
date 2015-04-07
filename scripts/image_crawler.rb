require 'rubygems'
require 'csv'
require 'timeout'
require 'open-uri'
require 'json'
products = []

def get_image(content = JSON.new)
	results = content["responseData"]["results"]
	results.sort_by! { |k| k["width"] }
	puts results[0]["url"].to_s + " " + product[0].to_s
	%x(wget #{URI::encode(results[0]["url"])} -O ./images/snapbizz_#{product[0]}.jpg)	
end
retries = 1
products = CSV.read("database.csv", :encoding => 'ISO-8859-1')
products[4999..9999].each do |product|
	begin
		Timeout::timeout(8){
			if (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xxlarge&q=#{product[0].to_s + " " + product[1]}")).read))["responseData"]["results"].size > 0
				get_image(content)
			elsif (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xlarge&q=#{product[0].to_s + " " + product[1]}")).read))["responseData"]["results"].size > 0
				get_image(content)
				# results = content["responseData"]["results"]
				# results.sort_by! { |k| k["width"] }
				# puts "XLarge " + results[0]["url"].to_s + " " + product[0].to_s
				# %x(wget #{URI::encode(results[0]["url"])} -O ./images/snapbizz_#{product[0]}.jpg)	
			elsif ( content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{product[0].to_s + " " + product[1]}")).read))["responseData"]["results"].size > 0
				get_image(content)
				# results = content["responseData"]["results"]
				# results.sort_by! { |k| k["width"] }
				# puts "NORMAL " + results[0]["url"].to_s + " " + product[0].to_s
				# %x(wget #{URI::encode(results[0]["url"])} -O ./images/snapbizz_#{product[0]}.jpg)			
			end
		}
	rescue Timeout::Error
		if retries > 0
			retries -= 1
			sleep 0.42 and retry
		else
			retries = 1
			next
		end
	rescue
		next
	end
end

# CSV.foreach("database.csv", :headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1')[4999..-1] do |row|
# 	product = Hash[row.headers[0..-1].zip(row.fields[0..-1])]
# 	products << product

# 	if (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xxlarge&q=#{product[:itemname]}")).read))["responseData"]["results"].size > 0
# 		results = content["responseData"]["results"]
# 		results.sort_by! { |k| k["width"] }
# 		puts "XXLarge " + results[0]["url"].to_s
# 		%x(wget #{results[0]["url"]} -O ./images/snapbizz_#{product[:barcode]}.jpg)	
# 	elsif (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xlarge&q=#{product[:itemname]}")).read))["responseData"]["results"].size > 0
# 		results = content["responseData"]["results"]
# 		results.sort_by! { |k| k["width"] }
# 		puts "XLarge " + results[0]["url"].to_s
# 		%x(wget #{results[0]["url"]} -O ./images/snapbizz_#{product[:barcode]}.jpg)	
# 	elsif ( content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{product[:itemname]}")).read))["responseData"]["results"].size > 0
# 		results = content["responseData"]["results"]
# 		results.sort_by! { |k| k["width"] }
# 		puts "NORMAL " + results[0]["url"].to_s
# 		%x(wget #{results[0]["url"]} -O ./images/snapbizz_#{product[:barcode]}.jpg)			
# 	end
# end





# if (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xxlarge&q=#{products[0][:itemname]}")).read))["responseData"]["results"].size > 0
# 	puts "XXLARGE"
# 	elsif (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xlarge&q=#{products[0][:itemname]}")).read))["responseData"]["results"].size > 0
# 		puts "XLARGE"
# 	elsif (content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{products[0][:itemname]}")).read))["responseData"]["results"].size > 0
# 		puts "NORMAL"
# 	end

# content = JSON.parse(open(URI::encode("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xxlarge&q=#{products[0][:itemname]}")).read)
# puts content.inspect
# puts content["responseData"]["results"].empty?
# puts content["responseData"]["results"][0]["url"]
# %x(wget #{content["responseData"]["results"][0]["url"]} -O ./images/snapbizz_#{product[0][:barcode]}.jpg)

# uri = URI.parse("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{products[0][:itemname]}")
# google_response = Net::HTTP.get_response(uri)

# puts products
# CSV.open('database.csv', 'r', ',') do |row|
#   puts row
# end

# puts csv
# Ccsv.foreach("./database.csv", ",") do |line|
#   puts line [0]
# end

# Ccsv.foreach("/etc/passwd",":") do |line|
#   puts line[0]
# end

# CSV.foreach("./database.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
#   tickers[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
# end

# filename = 'database.csv'
# file = File.new(filename, 'r')
# body = File.read('database.csv')
# csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
# puts body
# puts csv.to_a.map {|row| row.to_hash  }
