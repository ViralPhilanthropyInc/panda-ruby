require 'restclient'
require 'pandapay/util'
require 'pandapay/errors'
require 'stripe'

module PandaPay
  module StripeEcommerce
    class Charge
      extend PandaPay::Util

      attr_reader :stripe_charge

      def self.create(params={}, opts={})
        opts = symbolize_keys opts
        params = symbolize_keys params

        api_key = opts.fetch :api_key, PandaPay.api_key

        unless present? api_key
          PandaPay::AuthenticationError.api_key_not_set!
        end

        params_to_use = {}
        stripe_params = params.dup

        params_to_use[:donation_amount] = stripe_params.delete :donation_amount
        params_to_use[:destination] = stripe_params.delete :destination_ein
        params_to_use[:receipt_email] = stripe_params.delete :receipt_email
        params_to_use[:currency] = stripe_params.delete :currency

        stripe_params.each do |attr, value|
          params_to_use["stripe_params[#{attr}]"] = value
        end

        headers = {
            accept: :json,
            content_type: :json,
            params: params_to_use
        }.merge opts

        api_key = headers.delete(:api_key) || PandaPay.api_key
        api_base = headers.delete(:api_base) || "https://api.pandapay.io/v1"

        begin
          response = RestClient::Request.new(
            method: :post,
            url: File.join(api_base, "/donations"),
            user: api_key,
            password: nil,
            headers: headers
          ).execute
        rescue RestClient::Exception => e
          PandaPay::Error.raise_from_restclient_error! e
        end

        self.new JSON.parse(response), opts
      end

      protected

      def initialize(response, opts)
        response.each do |attr, value|
          if attr == 'stripe_response'
            @stripe_charge = Stripe::Util.convert_to_stripe_object(
              response,
              opts
            )
          else
            unless self.respond_to?("#{attr}=")
              self.class.send :attr_accessor, attr
            end

            self.send "#{attr}=", value
          end
        end
      end      
    end
  end
end
