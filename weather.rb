class Weather < Sinatra::Base

  # index hosts the main search box
  #
  get '/' do
    erb :index
  end

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
