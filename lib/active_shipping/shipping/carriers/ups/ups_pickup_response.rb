require 'virtus'
require 'time'

module ActiveMerchant
  module Shipping
    
    class UpsPickupResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :request, String
      attribute :pickup_confirmation_number, String      
      attribute :response, String            
    end    
  end
end