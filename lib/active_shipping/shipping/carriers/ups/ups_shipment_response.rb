require 'virtus'
require 'time'

module ActiveMerchant
  module Shipping

    class UpsError
      include Virtus.model

      attribute :severity, String      
      attribute :code, String      
      attribute :description, String      
    end
    
    class UpsShipment
      include Virtus.model
      
      attribute :currency, String
      attribute :transportation_charges, Float                 
      attribute :service_options_charges, Float
      attribute :total_charges, Float      
      attribute :trackingnumber, String      
    end    
    
    class UpsShipmentResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :errors, Array
      attribute :request, String
      attribute :response, String
      attribute :digest, String      
      attribute :shipment, UpsError                  
    end
    
  end
end