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
      attribute :shipment_identification_number, String      
      attribute :tracking_number, String
      attribute :label, String          
      attribute :request, String
      attribute :response, String     
      attribute :success, Boolean               
    end    
    
    class UpsShipmentResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :errors, Array
      attribute :request, String
      attribute :response, String
      attribute :digest, String      
      attribute :shipment, UpsShipment               
    end
    
  end
end