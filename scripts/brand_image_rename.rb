require 'rubygems'
require 'timeout'
require 'open-uri'
require 'json'
products = []
limit = 1000
offset = 0
total_count = 4151

# class String
#   def underscore
#   	self.gsub(/\s+/, "_").downcase.
#   	gsub(/'/,'').
#   	gsub(/[()]/, "").
#   	gsub(/&/,"").
#     gsub(/::/, '/').
#     gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
#     gsub(/([a-z\d])([A-Z])/,'\1_\2').
#     tr("-", "_").
#     downcase
#   end
# end

# def msg2str(msg)
#   case msg
#   when ::String
#     msg
#   when ::Exception
#     "#{msg.message} (#{msg.class}), backtrace: " << (msg.backtrace || []).to_json
#   else
#     msg.inspect
#   end
# end

# def with_open_uri(uri, params={}, &block)
#   begin
#     f = open(uri, params)
#     ret_val = block.(f)
#   ensure
#     f.send(f.respond_to?(:close!) ? :close! : :close) if f
#   end
#   ret_val
# end

Dir.glob("*.jpg").each { |filename| File.rename(filename, filename.gsub(/[^\w-]/, ''))}

# retries = 1
# for i in 0..((total_count/1000))
# 	if (content = JSON.parse(open(URI::encode("http://product.okfn.org/brand/api/v1/brand/?format=json&limit=#{limit}&offset=#{i*limit}")).read))["objects"].size > 0
# 		puts "Total of #{content["objects"].count} Images to be crawled"
# 		content["objects"].each do |brand|
# 			begin
# 				unless brand['brand_logo'].nil?
# 					filename = File.basename(URI.parse(brand['brand_logo']).path)
# 					if File.exist?("./Brands/#{filename}")
# 						puts "renaming #{filename} to snapbizz_#{brand['brand_nm'].sub(/\s+\Z/, '').underscore}.jpg}"
# 						%x(mv ./Brands/#{filename} ./Brands/snapbizz_#{brand['brand_nm'].sub(/\s+\Z/, '').underscore}.jpg)
# 					else
# 						puts "fetching #{brand['brand_logo']}"
# 						puts "Storing at #{brand['brand_nm'].sub(/\s+\Z/, "").underscore}"
# 						Timeout::timeout(8){
# 							%x(wget #{URI::encode(brand['brand_logo'])} -O ./Brands/snapbizz_#{brand['brand_nm'].sub(/\s+\Z/, '').underscore}.jpg)	
# 						}
# 					end
# 				end
# 			rescue Timeout::Error
# 				if retries > 0
# 					retries -= 1
# 					sleep 0.42 and retry
# 				else
# 					retries = 1
# 					next
# 				end
# 			rescue => e 
# 				puts("error while parsing request's body: #{msg2str(e)}")
# 				next
# 			end
# 		end
# 	end
# end