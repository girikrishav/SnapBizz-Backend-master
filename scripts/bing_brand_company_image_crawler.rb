#Rony: Account Key: LcuE9XQoL7HjktFcrKBv7igXcBJ8GwpyZ0A+yt2UnuA
#Kannan: Account Key: lH06Lnxj0iLFXJ3YxOAmOhGYZThhdy3txzWozDc5lr8
#Yash: 17uljJuVHRqtLMgfikRTYvyFcJrYBmeN/WqpZrUxukI (50k requests)

require 'rubygems'
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

`mkdir -p brand-images brand-images/images1 brand-images/images2 brand-images/images3 brand-images/images4 brand-images/images5`
brands = CSV.read("brands.csv", :encoding => 'ISO-8859-1', :headers => true, :header_converters => :symbol)
brands.each do |brand|

	# product[1].encode!( product[1].encoding, "binary", :invalid => :replace, :undef => :replace)

	unless File.exist?("./brand-images/images1/snapbizz_#{brand[:brandname]}.jpg")
		retries = 1
		images = Binged::Client.new(:account_key => 'lH06Lnxj0iLFXJ3YxOAmOhGYZThhdy3txzWozDc5lr8').image.containing("#{product[0].to_s + " " + product[1]}").each {|image| image}
		if images.size <= 0
			images = Binged::Client.new(:account_key => 'lH06Lnxj0iLFXJ3YxOAmOhGYZThhdy3txzWozDc5lr8').image.containing("#{product[1]}").each {|image| image} 
		end

		begin
			Timeout::timeout(60){
				%x(wget #{URI::encode(images[0]["media_url"])} -O ./images-first/snapbizz_#{product[0]}.jpg)	if images[0]
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
				%x(wget #{URI::encode(images[0]["media_url"])} -O brand-images/images1/snapbizz_#{product[0]}.jpg)	if images[0]
				%x(wget #{URI::encode(images[1]["media_url"])} -O brand-images/images2/snapbizz_#{product[0]}.jpg) if images[1]
				%x(wget #{URI::encode(images[2]["media_url"])} -O brand-images/images3/snapbizz_#{product[0]}.jpg) if images[2]
				%x(wget #{URI::encode(images[3]["media_url"])} -O brand-images/images4/snapbizz_#{product[0]}.jpg) if images[3]
				%x(wget #{URI::encode(images[4]["media_url"])} -O brand-images/images5/snapbizz_#{product[0]}.jpg) if images[4]
				# %x(wget #{URI::encode(images[5]["media_url"])} -O ./images6/snapbizz_#{product[0]}.jpg) if images[5]
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
		rescue => e
			puts("error while parsing request's body: #{msg2str(e)}")
			next
		end
	else
		puts "File exists : snapbizz_#{product[0]}.jpg"
	end
end