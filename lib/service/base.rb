module Service
  class Base
    include HTTParty

    def self.handle_response(action, params = {}, response)

      begin
        return response.code, response.parsed_response if response.code == 200
        return response.code, nil if response.code == 404

        raise ::Service::Error::NetworkError.new(action, self.name.split('::').first, params, response)
      rescue HTTParty::ResponseError => exception
        raise ::Service::Error::ClientError.new(action, self.name.split('::').first, params, exception)
      end
    end

  end
end
