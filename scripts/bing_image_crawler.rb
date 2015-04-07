#Rony: Account Key: LcuE9XQoL7HjktFcrKBv7igXcBJ8GwpyZ0A+yt2UnuA
#Kannan: Account Key: lH06Lnxj0iLFXJ3YxOAmOhGYZThhdy3txzWozDc5lr8
#Yash: 17uljJuVHRqtLMgfikRTYvyFcJrYBmeN/WqpZrUxukI (50k requests)

require 'rubygems'
require 'daemons'
require 'csv'
require 'timeout'
require 'json'
require 'binged'

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
pwd  = File.dirname(File.expand_path(__FILE__))

`mkdir -p #{pwd}/product_images #{pwd}/product_images/images1 #{pwd}/product_images/images2 #{pwd}/product_images/images3 #{pwd}/product_images/images4 #{pwd}/product_images/images5 #{pwd}/product_images/first_result`
products = CSV.read("#{pwd}/database.csv", {:headers => true, :header_converters => :symbol, :converters => :all, :encoding => 'ISO-8859-1'})

CSV.open("#{pwd}/product_images/product_image_data.csv", "wb") do |csv|
	csv << ["barcode", "productname", "mrp", "first_result", "image1", "image2", "image3", "image4", "image5"]
	for i in 15000..15099
		product = products[i]
	# products[15000..15099].each do |product|
		product[:productname].encode!( product[:productname].encoding, "binary", :invalid => :replace, :undef => :replace)
		unless File.exist?("#{pwd}/product_images/first_result/snapbizz_#{product[:barcode]}.jpg")
			retries = 1
			images = Binged::Client.new(:account_key => '17uljJuVHRqtLMgfikRTYvyFcJrYBmeN/WqpZrUxukI').image.containing("#{product[:barcode].to_s + " " + product[:productname][/[^0-9]+/]}").each {|image| image}
			if images.size <= 0
				images = Binged::Client.new(:account_key => '17uljJuVHRqtLMgfikRTYvyFcJrYBmeN/WqpZrUxukI').image.containing("#{product[:productname][/[^0-9]+/]}").each {|image| image} 
			end

			begin
				Timeout::timeout(60){
					%x(wget #{URI::encode(images[0]["media_url"])} -O #{pwd}/product_images/first_result/snapbizz_#{product[:barcode]}.jpg)	if images[0]
					product[:first_result] = images[0]["media_url"] rescue nil
				}
			rescue Timeout::Error
				if retries > 0
					retries -= 1
					sleep 0.42 and retry
				else
					retries = 1
					puts("TimeOut Error")
					next
				end
			end
			images.sort_by! {|img| img["width"].to_i}
			images.reverse!

			begin
				Timeout::timeout(60){
					product[:image1] = images[0]["media_url"] rescue nil
					%x(wget #{URI::encode(images[0]["media_url"])} -O #{pwd}/product_images/images1/snapbizz_#{product[:barcode]}.jpg) if images[0]
					product[:image2] = images[1]["media_url"] rescue nil
					%x(wget #{URI::encode(images[1]["media_url"])} -O #{pwd}/product_images/images2/snapbizz_#{product[:barcode]}.jpg) if images[1]
					product[:image3] = images[2]["media_url"] rescue nil
					%x(wget #{URI::encode(images[2]["media_url"])} -O #{pwd}/product_images/images3/snapbizz_#{product[:barcode]}.jpg) if images[2]
					product[:image4] = images[3]["media_url"] rescue nil
					%x(wget #{URI::encode(images[3]["media_url"])} -O #{pwd}/product_images/images4/snapbizz_#{product[:barcode]}.jpg) if images[3]
					product[:image5] = images[4]["media_url"] rescue nil
					%x(wget #{URI::encode(images[4]["media_url"])} -O #{pwd}/product_images/images5/snapbizz_#{product[:barcode]}.jpg) if images[4]
				}
				csv << product
			rescue Timeout::Error
				if retries > 0
					retries -= 1
					sleep 0.42 and retry
				else
					retries = 1
					puts("TimeOut Error")
					next
				end
			rescue => e
				puts("error while parsing request's body: #{msg2str(e)}")
				next
			end
		else
			puts "File exists : snapbizz_#{product[:barcode]}.jpg"
		end
	end
end