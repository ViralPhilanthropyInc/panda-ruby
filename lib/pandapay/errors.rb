require 'restclient/exceptions'
require 'json'

module PandaPay
  class Error < RuntimeError
    def self.raise_from_restclient_error!(exception)
      if exception.http_code == 400
        raise PandaPay::RequestError.new JSON.parse(exception.http_body)
      else
        raise exception
      end
    end
  end

  class AuthenticationError < PandaPay::Error
    DEFAULT_MESSAGE = "No API key provided. Set your API key using \"PandaPay.api_key = <API-KEY>\". You can generate API keys from the PandaPay web interface. See https://www.pandapay.io/docs/api-reference for details, or email support@pandpay.io if you have any questions."

    def initialize(message=DEFAULT_MESSAGE)
      super
    end

    def self.api_key_not_set!
      raise self.new
    end
  end

  class RequestError < PandaPay::Error
    attr_reader :error_details

    def initialize(error_details={})
      @error_details = error_details

      super self.error_details.inspect
    end
  end
end

