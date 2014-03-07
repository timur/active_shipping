require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
        
    class UpsShipmentConfirmResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :errors, Array
      attribute :request, String
      attribute :response, String
                      
    end
  end
end