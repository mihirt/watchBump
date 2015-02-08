require 'FileUtils'

if ARGV[0] != nil then
   FileUtils.cd("pebbleApp")
   `pebble build`
   puts "======[Deploying...]======"
   `pebble install --phone #{ARGV[0]}`
else
	puts "[ERROR]: Please use IP of phone as parameter"
end