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
      
      def is_success?
        success = false
        if notes.size > 0
          notes.each do |note|
            if note.action_code && note.action_code == SUCCESS
              success = true
            end
          end
        end
        success
      end      
    end
  end
end