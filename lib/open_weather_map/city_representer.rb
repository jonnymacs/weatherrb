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
