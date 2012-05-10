# myapp.rb
require 'sinatra'

# get '/:name' do | name |
#   "Hello #{name}"
# end

set(:probability) { |value| condition { rand <= value } }

get '/win_a_car', probability: 0.5 do
  puts :probability
  "You won!"
end

get '/win_a_car' do
  "Sorry, you lost."
end

get '/favicon.ico' do
  ""
end
