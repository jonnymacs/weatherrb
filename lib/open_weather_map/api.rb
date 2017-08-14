# The OpenWeatherMap::Api inherits HTTParty support
# from the Serivce::Base class.
# Currently there is one static class method
# OpenWeatherMap::Api.get_weather_by_city_name(:cityname)
#
module OpenWeatherMap
  class Api < ::Service::Base

    APP_ID = "d8e16e999743f4629003b1466d88932b".freeze #ideally this is in an encrypted config file
    WEATHER_PATH = "/data/2.5/weather".freeze
    base_uri 'http://api.openweathermap.org/'
    format :json

    # get weather by city name
    # https://openweathermap.org/current#name
    #
    def self.get_weather_by_city_name(cityname)

      params = { q: cityname }
      params.merge!('appid': APP_ID, 'units': 'imperial')

      headers = { "Accept" => "application/json, text/javascript, */*; q=0.01",
                  "Accept-Encoding" => "gzip,deflate,sdch",
                  "Accept-Language" => "en-US,en;q=0.8"}

      response = get("#{WEATHER_PATH}?#{Rack::Utils.build_query(params)}", headers: headers)
      handle_response(__method__, response)
    end

  end
end
