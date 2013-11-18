require 'virtus'

module ActiveMerchant
  module Shipping

    class UpsTrackingEvent
      include Virtus.model
    
      attribute :city, String
      attribute :state_province_code, String           
      attribute :postal_code, String
      attribute :country_code, String
      attribute :code, String
      attribute :description, String              
      attribute :signed_for_by_name, String              
      attribute :status_type_code, String              
      attribute :status_description, String              
      attribute :status_code, String              
      attribute :date, String                                            
      attribute :time, String                                                  
    end
                
    class UpsTrackingResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :tracking_events, Array
      attribute :shipper_number, String      
      attribute :ship_to_addressline1, String      
      attribute :ship_to_addressline2, String      
      attribute :city, String      
      attribute :state_province_code, String                              
      
      attribute :postal_code, String                              
      attribute :country_code, String                              
      attribute :description, DateTime                              
      attribute :pickup_date, String                              

      attribute :request, String
      attribute :response, String      

      def to_s
        "Success: #{success} | Notes: #{notes.to_s}"
      end
    end
  end
end