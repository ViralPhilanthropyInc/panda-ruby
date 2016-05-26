require "pandapay/version"
require "pandapay/stripe_ecommerce"

module PandaPay
  def self.api_key=(new_api_key)
    @api_key = new_api_key
  end

  def self.api_key
    @api_key
  end
end
