module Service
  module Error

    class NetworkError < RuntimeError
      def initialize(action, klass, params, response)
        # poor mans underscore
        klass = klass.gsub(/(.)([A-Z])/,'\1_\2').downcase
        super I18n.t "services.#{klass}.network.#{action.to_s}", { response: response }
      end
    end

    class ClientError < RuntimeError
      def initialize(action, klass, params, exception)
        klass = klass.gsub(/(.)([A-Z])/,'\1_\2').downcase
        super I18n.t "services.#{klass}.client.#{action.to_s}", { exception: exception }
      end
    end

  end
end
