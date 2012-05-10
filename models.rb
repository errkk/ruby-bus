require 'rubygems'

require 'dm-core'  
require 'dm-timestamps'  
require 'dm-validations'  
require 'dm-migrations'
require 'dm-mysql-adapter'

require 'json'
require 'net/http'



DataMapper.setup :default, "sqlite://#{Dir.pwd}/database.db" 

class BusStop
	include DataMapper::Resource


	property :id		, Integer		, unique_index: true, key: true
	property :lat		, Float
	property :lng		, Float
	property :name	, String
	property :direction	, String
	property :towards	, String
	property :stopIndicator	, String
	property :smsCode	, String
	property :routes	, String

	# DataMapper.auto_upgrade!
	DataMapper.auto_migrate!



end



def get_bus_stops!

	bb = [50,0.3,52,-0.3]
	# bb = [51,0.3,51.5,0.2]

	url = "http://countdown.tfl.gov.uk/markers/swLat/#{bb[0]}/swLng/#{bb[1]}/neLat/#{bb[2]}/neLng/#{bb[3]}/?_dc=1315936072189"

	resp = Net::HTTP.get_response( URI.parse(url) )

	data = resp.body

	result = JSON.parse(data).each do | item | 

		item[1].each { | stop | busstop = BusStop.create stop; puts busstop }

		busstop.errors.each { |error| puts error }
		
	end


	if result.has_key? 'Error'
      raise "web service error"
  end

end

# get_bus_stops!

items = BusStop.all direction: 'w'

puts items