require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexShipmentResponse
      include Virtus
      
      SUCCESS = "Success"

      attribute :success, Boolean      
      attribute :notes, Array
      attribute :request, String
      attribute :response, String      
      attribute :label, String
      attribute :trackingnumber, String                  
      
    end
  end
end