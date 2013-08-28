require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexTrackingRequest
      include Virtus

      attribute :key, String
      attribute :password, String
      attribute :accountNumber, String      
      attribute :meterNumber, String
      
      attribute :trackingnumber, String      
      
    end
  end
end