require 'rubygems'
require 'rack'
require 'rack/cache'
require 'sinatra'
require 'logger'
require 'httparty'
require 'multi_json'
require 'i18n'
require 'representable'
require 'representable/json'

# load service first
Dir.glob('./lib/service/*.rb').each do |req|
  require req
end

Dir.glob('./lib/**/*.rb').sort.each do |req|
  require req
end

I18n.load_path += Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.default_locale = :'en-US'

# use a file cache for this excerise.
# memcached would be the choice if
# running multiple app instances
#
use Rack::Cache,
  metastore:    'file:./tmp/cache/rack/meta',
  entitystore:  'file:./tmp/cache/rack/body',
  verbose:      true
  
class Weather < Sinatra::Base

  # index hosts the main search box
  #
  get '/' do
    erb :index
  end

  # search endpoint accepts a query param
  # checks rack-cache for the url
  # if cache is cold, execute a call to open weather api
  # and render results
  get '/search' do

    # rack-cache client policy - cache 4 hours
    expires (Time.now + 14400).httpdate

    city = params["query"]

    begin
      # query the open weather map api for the provided query
      status, result = OpenWeatherMap::Api.get_weather_by_city_name(city)
      # check the status code from the backend
      # and render the appropriate partial view
      #
      case status
      when 200
        @city = OpenWeatherMap::CityRepresenter.new(OpenStruct.new).from_hash(result)
        erb :_weather, layout: false
      when 404
        erb :_no_results, layout: false
      else
        @message = "unknown error"
        erb :_error, layout: false
      end
    rescue Service::Error::NetworkError, Service::Error::ClientError => message
      @message = message
      erb :_error, layout: false
    end

  end

end
