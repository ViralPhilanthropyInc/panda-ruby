module PandaPay
  module Util
    def present?(obj)
      return false if obj.nil?

      return false if obj.respond_to?(:length) && (obj.length == 0)

      true
    end

    def symbolize_keys(hash)
      new_hash = {}

      hash.each do |k, v|
        new_hash[k.to_sym] = v
      end

      new_hash
    end
  end
end
