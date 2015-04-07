require 'rubygems'
require 'daemons'

pwd  = File.dirname(File.expand_path(__FILE__))
file = pwd + '/bing_image_crawler.rb'

Daemons.run_proc(
   'snapbizz', # name of daemon
   :log_output => true
 ) do
   exec "ruby #{file}"
end