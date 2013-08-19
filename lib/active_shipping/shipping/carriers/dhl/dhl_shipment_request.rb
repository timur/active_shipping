require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping        
    
    # dutiable - zollpflichtig
    class DhlShipmentRequest
      include Virtus
      include ActiveModel::Validations      
      
      # authorization
      attribute :site_id, String
      attribute :password, String      
      
      # mandatory    
      attribute :language_code, String
      attribute :pieces_enabled, String
      attribute :shipper_account_number, String 
      
      validates :language_code, :pieces_enabled, :shipper_account_number, presence: true
      
      # S (Shipper) - default
      # R (Recipient)
      # T (Third Party/Other)
      attribute :shipper_payment_type, String
      attribute :duty_payment_type, String       
      # Required if Duty Payment Type is #T'           
      attribute :duty_account_number, String                        
      
      # Shipment bill to account. Required if ShippingPaymentType is other than ‘S’
      attribute :billing_account_number, String   
      
      # Consignee = Reciever
      # mandatory Consignee
      attribute :consignee_company, String               
      attribute :consignee_address_line, String                     
      attribute :consignee_city, String                                 
      attribute :consignee_postalcode, String                           
      attribute :consignee_countrycode, String                                 
      attribute :consignee_countryname, String                                       

      validates :consignee_company, 
                :consignee_address_line, 
                :consignee_city, 
                :consignee_postalcode, 
                :consignee_countrycode, 
                presence: true
            
      # Type Contact not mandatory but we should use
      attribute :contact_consignee_fullname, String 
      attribute :contact_consignee_phonenumber, String 
      attribute :contact_consignee_phoneext, String 
      
      attribute :pieces, Array[DhlPiece]
      
      # Shipment Details
      # mandatory      
      attribute :shipment_details_number_of_pieces, Integer 
      attribute :shipment_details_weight, Float
      attribute :shipment_details_global_product_code, String             
      attribute :shipment_details_local_product_code, String                   
      attribute :shipment_details_date, Date    
      attribute :shipment_details_packageType, String
      attribute :shipment_details_currencyCode, String
      # optional
      attribute :shipment_details_insured_amount, Float      
      
      validates :shipment_details_number_of_pieces, 
                :shipment_details_weight, 
                :shipment_details_global_product_code, 
                :shipment_details_local_product_code, 
                :shipment_details_date,
                presence: true                           
      
			                                                        
      # Shipper
      # mandatory
      attribute :shipper_shipper_id, String                   
      attribute :shipper_company, String                         
      attribute :shipper_address_line, String  
      attribute :shipper_city, String                                           
      attribute :shipper_countrycode, String                                     
      attribute :shipper_countryname, String                                                 
      attribute :shipper_postalcode, String  
      
      validates :shipper_shipper_id, 
                :shipper_company, 
                :shipper_address_line, 
                :shipper_countrycode, 
                :shipper_countryname,
                :shipper_city,
                presence: true           
                
      # Type Contact not mandatory but we should use
      attribute :contact_shipper_fullname, String 
      attribute :contact_shipper_phonenumber, String 
      attribute :contact_shipper_phoneext, String                                 
        
      
      # Dutiable
      attribute :dutiable, Boolean
      attribute :declared_currency, String                                           
      attribute :declared_value, Float                                                 
      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end  
            
      def isDutiable
        dutiable ? "Y" : "N"
      end

      def billingAccountNumber?
        if billing_account_number && billing_account_number != "S"
          return true
        else
          return false
        end
      end
            
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/dhl/templates/shipment_validation.xml.erb"
        end
    end
  end
end