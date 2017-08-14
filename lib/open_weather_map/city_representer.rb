
# OpenWeatherMap::CityRepresenter parses a successful
# response from the open weather map search api
# onto a model object that supports the defined
# properties (or an OpenStruct)
#
# The response is parsed / flattened for ease of use
# in the app / ui
#
module OpenWeatherMap
  class CityRepresenter < Representable::Decorator
    include Representable::JSON

    property :coord
    property :weather, parse_filter: -> (weather, options) { weather.first }

    nested :main do
      property :temp
    end

  end
end
