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

retries = 1

`mkdir -p images1`
`mkdir -p images2`
`mkdir -p images3`
`mkdir -p images4`
`mkdir -p images5`
`mkdir -p images6`
products = CSV.read("database.csv", :encoding => 'ISO-8859-1')
products[8542..9999].each do |product|
	unless File.exist?("./images1/snapbizz_#{product[0]}.jpg")
		begin
			Timeout::timeout(15){
				images = Binged::Client.new(:account_key => 'lH06Lnxj0iLFXJ3YxOAmOhGYZThhdy3txzWozDc5lr8').image.containing("#{product[0].to_s + " " + product[1]}").each {|image| image}
				images.sort_by! {|img| img["width"].to_i}
				images.reverse!
				
				%x(wget #{URI::encode(images[0]["media_url"])} -O ./images1/snapbizz_#{product[0]}.jpg)	
				%x(wget #{URI::encode(images[1]["media_url"])} -O ./images2/snapbizz_#{product[0]}.jpg) if images[1]
				%x(wget #{URI::encode(images[2]["media_url"])} -O ./images3/snapbizz_#{product[0]}.jpg) if images[2]
				%x(wget #{URI::encode(images[3]["media_url"])} -O ./images3/snapbizz_#{product[0]}.jpg) if images[3]
				%x(wget #{URI::encode(images[4]["media_url"])} -O ./images3/snapbizz_#{product[0]}.jpg) if images[4]
				%x(wget #{URI::encode(images[5]["media_url"])} -O ./images3/snapbizz_#{product[0]}.jpg) if images[5]
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
		puts "File exists : snapbizz_#{product[0]}"
	end
end