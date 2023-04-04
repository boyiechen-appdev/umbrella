require "open-uri"
require "json"

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


# fetch weather information
weather_api_key = "3RrQrvLmiUayQ84JSxL8D2aXw99yRKlx1N4qFDUE"
weather_uri = "https://api.pirateweather.net/forecast/#{weather_api_key}/#{},#{}"
