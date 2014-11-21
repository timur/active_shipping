require 'virtus'

module ActiveMerchant
  module Shipping

    class FedexBookPickupResponse
      include Virtus.model
    
      attribute :success, Boolean
      attribute :notes, Array

      attribute :request, String
      attribute :response, String  
      
      attribute :pickup_confirmation_number, String    
      attribute :location, String          
      
      def success?
        @success
      end
            
    end
  end
end