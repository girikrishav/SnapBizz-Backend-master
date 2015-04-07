require 'rubygems'
# require 'csv'
require 'timeout'
require 'open-uri'
require 'json'
require 'hidemyass'

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

def get_image(product, content = JSON.new)
	results = content["responseData"]["results"]
	results.sort_by! { |k| k["width"] }
	if content["responseData"]["cursor"]["resultCount"].to_i > 0
		%x(wget #{URI::encode(results[0]["url"])} -O ./images1/snapbizz_#{product[0]}.jpg)	
		%x(wget #{URI::encode(results[1]["url"])} -O ./images2/snapbizz_#{product[0]}.jpg) if content["responseData"]["cursor"]["resultCount"].to_i > 1
		%x(wget #{URI::encode(results[2]["url"])} -O ./images3/snapbizz_#{product[0]}.jpg) if content["responseData"]["cursor"]["resultCount"].to_i > 2
	end
end
retries = 1
`mkdir -p images1`
`mkdir -p images2`
`mkdir -p images3`
products = CSV.read("database.csv", :encoding => 'ISO-8859-1')
count = 0
arr = []
HideMyAss.options[:max_concurrency] = 3
base_uri = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0"
products[4999..9999].each do |product|
	begin
		Timeout::timeout(8){
			sleep(1)
			if (content = JSON.parse(HideMyAss.get(URI::encode("#{base_uri}&imgsz=xxlarge&q=#{product[0].to_s + " " + product[1]}"), timeout: 2).response_body))["responseData"]["results"].size > 0
				get_image(product, content) if content["responseData"]["results"].size > 0
			elsif (content = JSON.parse(HideMyAss.get(URI::encode("#{base_uri}&&imgsz=xlarge&q=#{product[0].to_s + " " + product[1]}"), timeout: 2).response_body))["responseData"]["results"].size > 0
				get_image(product, content) if content["responseData"]["results"].size > 0
			elsif ( content = JSON.parse(HideMyAss.get(URI::encode("#{base_uri}&&q=#{product[0].to_s + " " + product[1]}"), timeout: 2).response_body))["responseData"]["results"].size > 0
				get_image(product, content) if ["responseData"]["results"].size > 0
			end
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
end