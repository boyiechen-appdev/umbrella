require "open-uri"
require "json"
require "ascii_charts"

puts "========================================\n    Will you need an umbrella today?    \n========================================\n\n"
puts "Where are you located?"

user_location = gets.chomp()
# user_location = "chicago"
# puts user_location

# fetch user location latitude and logitude
gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_response = URI.open(gmaps_url).read
parsed_response = JSON.parse(raw_response)

location = parsed_response.fetch("results").at(0).fetch("geometry").fetch("location")

latitude = location.fetch("lat")
longitude = location.fetch("lng")
# p latitude, longitude

puts "Checking the weather at #{user_location}...."
puts "Your coordinates are #{latitude}, #{longitude}"


# fetch weather information
weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
weather_uri = "https://api.pirateweather.net/forecast/#{weather_api_key}/#{latitude},#{longitude}"
response = URI.open(weather_uri).read
parsed_response = JSON.parse(response)
# p parsed_reponse.keys

weather_info_now = parsed_response.fetch("currently")
weather_info_forecast = parsed_response.fetch("hourly").fetch("data")[1..12]
# p parsed_response.keys
# p parsed_response.fetch("hourly").keys
# p parsed_response.fetch("hourly").fetch("data").at(1)

temp_now = weather_info_now.fetch("temperature")
puts "It is currently #{temp_now} °F.\n"


# weather forecast

# Within the next hour (minutely data)
# since there might not be minutely data, we put a false inside `fetch`
# so our code won't break
weather_info_minutely = parsed_response.fetch("minutely", false)
if weather_info_minutely
  puts "Next hour: #{weather_info_minutely.fetch("summary")}"
end

# Next 12 hours
puts "\nHours from now vs Precipitation probability"
# p weather_info.fetch("precipProbability")

# use a for loop to obtain the precipitation probability in the next 12 hrs
plot_data = []

prob_precip = 0
12.times do |hour|
  # p weather_info_forecast.at(hour).fetch("precipProbability")
  prob =  weather_info_forecast.at(hour).fetch("precipProbability") * 100
  prob_precip = [prob, prob_precip].max
  plot_data.push([hour+1, prob])
end


# ACSII Charts
puts AsciiCharts::Cartesian.new(plot_data).draw

# bringing umbrella message
prob_threshold = 10
if prob_precip >= prob_threshold
  puts "You might want to take an umbrella"
else
  puts "You probably won't need an umbrella"
end
