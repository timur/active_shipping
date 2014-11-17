require 'virtus'

module ActiveMerchant
  module Shipping


    class FedexTrackingEvent
      include Virtus.model
    
      attribute :timestamp, DateTime
      attribute :event_type, String           
      attribute :event_description, String
      attribute :city, String
      attribute :postal_code, String
      attribute :country_code, String                                
      attribute :residential, Boolean                                      
      attribute :arrival_location, String                                            
    end
                
    class FedexTrackingResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :tracking_number_unique_identifier, String
      attribute :ship_timestamp, DateTime
      attribute :tracking_events, Array
      attribute :request, String
      attribute :response, String  
      
      def success?
        @success
      end    
      
      def to_s
        "Success: #{success} | Notes: #{notes.to_s}"
      end
    end
  end
end