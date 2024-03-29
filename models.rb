require 'rubygems'

require 'dm-core'  
require 'dm-timestamps'  
require 'dm-validations'  
require 'dm-migrations'
require 'dm-geokit'

require 'json'
require 'net/http'


DataMapper.setup :default, "sqlite://#{Dir.pwd}/database.db" 

class BusStop
	include DataMapper::Resource

	property :id		, Integer	, unique_index: true, key: true
	property :name		, String
	property :direction	, String
	property :towards	, String
	property :letter	, String


	property :lat		, Float	, index: true
	property :lng		, Float	, index: true
	
	DataMapper.auto_upgrade!
	# DataMapper.auto_migrate!

	def smsCode= (v)
	end

	def routes= (v)
	end

	def stopIndicator= (v)
		self.letter = v
	end

	def self.near( lat, lng )
		# unless ll.is_a? end
		puts lat, lng
	end


end

DataMapper.finalize

def get_bus_stops!
	# bb = [50,0.3,52,-0.3]
	bb = [51,0.3,51.5,0.2]
	url = "http://countdown.tfl.gov.uk/markers/swLat/#{bb[0]}/swLng/#{bb[1]}/neLat/#{bb[2]}/neLng/#{bb[3]}/?_dc=1315936072189"
	resp = Net::HTTP.get_response( URI.parse(url) )
	data = resp.body
	result = JSON.parse(data).each do | item | 
		item[1].each do | stop | 
			bs = BusStop.create stop

			bs.errors.each do |error|  
			    puts error  
			end  

		end
	end
	if result.has_key? 'Error'
      raise "web service error"
  end
end

# get_bus_stops!



items = BusStop.near 1, 2
# items = BusStop.all(:address.near => {:origin => 'Portland, OR', :distance => 5.mi})
# items.each { |item| p item; puts "\r" }



