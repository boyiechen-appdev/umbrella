require "open-uri"
require "json"
require "ascii_charts"

puts "========================================\n    Will you need an umbrella today?    \n========================================\n\n"
p "Where are you located?"

# user_location = gets.chomp()
user_location = "chicago"
p user_location

# fetch user location latitude and logitude
gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_response = URI.open(gmaps_url).read
parsed_response = JSON.parse(raw_response)

location = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")
p latitude, longitude

p "Checking the weather at #{user_location}"
p "Your coordinates are #{latitude}, #{longitude}"


# fetch weather information
weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_uri = "https://api.pirateweather.net/forecast/#{weather_api_key}/#{latitude},#{longitude}"
response = URI.open(weather_uri).read
parsed_reponse = JSON.parse(response)
# p parsed_reponse.keys

weather_info = parsed_reponse.fetch("currently")
p weather_info

temp_now = weather_info.fetch("temperature")
p "It is currently #{temp_now} °F."

time_fetched = Time.at(weather_info.fetch("time"))
p time_fetched


# ACSII Charts
puts AsciiCharts::Cartesian.new([[0, 1], [1, 3], [2, 7], [3, 15], [4, 4]]).draw
