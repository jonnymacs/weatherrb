# Service::Error defines generic service errors
#
module Service
  module Error

    class NetworkError < RuntimeError
      def initialize(action, klass, params, response)
        # poor mans underscore
        klass = klass.gsub(/(.)([A-Z])/,'\1_\2').downcase

        # error parsing should be api specific.
        # There are various ways to implement this
        # any of which could include an error representer
        #
        message = response["message"] ? response["message"] : response
        super I18n.t "services.#{klass}.network.#{action.to_s}", { message: message }
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
