require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlShipmentResponse
      include Virtus.model
      
      SUCCESS = "Success"
      
      attribute :notes, Array
      attribute :request, String
      attribute :response, String      
      attribute :label, String
      attribute :airwaybillnumber, String                  
      attribute :airwaybillnumbers, Array                        
      attribute :shipment_date, Date
      attribute :product_name, String
      attribute :delivery_time_code, String             
      attribute :rated, String                              
      attribute :chargable_weight, Float                        
      attribute :dimensional_weight, Float   
      attribute :customer_id, String 
         
      attribute :shipper_company, String                         
      attribute :shipper_address_line, String                               
      attribute :shipper_countrycode, String                                     
      attribute :shipper_postalcode, String
      attribute :shipper_city, String                                                        
      attribute :shipper_registered_account, String                                                  
      attribute :contact_shipper_fullname, String 
      attribute :contact_shipper_phonenumber, String 
      attribute :contact_shipper_phoneext, String                                 

      attribute :consignee_company, String                         
      attribute :consignee_address_line, String                               
      attribute :consignee_countrycode, String                                     
      attribute :consignee_postalcode, String
      attribute :consignee_city, String                                                        
      attribute :consignee_registered_account, String                                                  
      attribute :contact_consignee_fullname, String 
      attribute :contact_consignee_phonenumber, String 
      attribute :contact_consignee_phoneext, String                                 
      
      
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