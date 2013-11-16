require 'virtus'

module ActiveMerchant
  module Shipping

    class DhlTrackingEvent
      include Virtus.model
    
      attribute :date, Date
      attribute :time, Time           
      attribute :event_code, String
      attribute :event_description, String
      attribute :service_area_description, String
      attribute :service_area_code, String                                

    end
                
    class DhlTrackingResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :tracking_events, Array
      attribute :origin_service_area_code, String      
      attribute :origin_description, String      
      attribute :destination_service_area_code, String      
      attribute :destination_description, String      
      attribute :shipper_name, String                              

      attribute :shipper_account_number, String                              
      attribute :consignee_name, String                              
      attribute :shipment_date, DateTime                              
      attribute :shipment_description, String                              
      attribute :shipper_city, String    
      attribute :shipper_countrycode, String                          
      attribute :consignee_city, String                              
      attribute :consignee_postalcode, String                              
      attribute :consignee_countrycode, String                              
      attribute :shipper_referenceid, String                                                

      attribute :request, String
      attribute :response, String      

      def to_s
        "Success: #{success} | Notes: #{notes.to_s}"
      end
    end
  end
end