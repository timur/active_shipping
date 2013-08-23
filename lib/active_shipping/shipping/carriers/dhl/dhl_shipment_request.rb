require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping        
    
    # dutiable - zollpflichtig
    class DhlShipmentRequest
      include Virtus
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants        
      
      # authorization
      attribute :site_id, String
      attribute :password, String      
      
      # mandatory    
      attribute :language_code, String # not inputed by user
      attribute :pieces_enabled, String # default Y for licence plate
      attribute :shipper_account_number, String # dhl account number otherwise ours
      
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
      attribute :consignee_company, String # user input               
      attribute :consignee_address_line, String # user input                                    
      attribute :consignee_city, String # user input                                 
      attribute :consignee_postalcode, String # user input                           
      attribute :consignee_countrycode, String # user input                    
      attribute :consignee_countryname, String # lookup mapping table                                       

      validates :consignee_company, 
                :consignee_address_line, 
                :consignee_city, 
                :consignee_postalcode, 
                :consignee_countrycode, 
                presence: true
            
      # Type Contact not mandatory but we should use
      attribute :contact_consignee_fullname, String # user input                                  
      attribute :contact_consignee_phonenumber, String # user input                                  
      attribute :contact_consignee_phoneext, String # user input                                  
      
      attribute :pieces, Array[DhlPiece]
      
      # Shipment Details
      # mandatory      
      attribute :shipment_details_number_of_pieces, Integer # calculated by us
      attribute :shipment_details_weight, Float # calculated by us
      attribute :shipment_details_global_product_code, String # user input            
      attribute :shipment_details_local_product_code, String # user input                               
      attribute :shipment_details_date, Date # current date by us
      attribute :shipment_details_currencyCode, String # calculated by us
      attribute :shipment_details_content, String # user input                                     
      # optional
      attribute :shipment_details_insured_amount, Float      
      
      validates :shipment_details_number_of_pieces, 
                :shipment_details_weight, 
                :shipment_details_global_product_code, 
                :shipment_details_local_product_code, 
                :shipment_details_date,
                :shipment_details_content,
                presence: true                           
      
			                                                        
      # Shipper
      # mandatory
      attribute :shipper_shipper_id, String # probably enviaya account number                   
      attribute :shipper_company, String # user input                                                          
      attribute :shipper_address_line, String # user input                                   
      attribute :shipper_city, String # user input                                                                              
      attribute :shipper_countrycode, String # user input                                                                        
      attribute :shipper_countryname, String # calculated by us                                                                                    
      attribute :shipper_postalcode, String # user input                                     
      
      validates :shipper_shipper_id, 
                :shipper_company, 
                :shipper_address_line, 
                :shipper_countrycode, 
                :shipper_countryname,
                :shipper_city,
                presence: true           
                
      # Type Contact not mandatory but we should use
      attribute :contact_shipper_fullname, String # user input                                    
      attribute :contact_shipper_phonenumber, String # user input                                    
      attribute :contact_shipper_phoneext, String # user input                                                                    
              
      # Dutiable
      attribute :dutiable, Boolean # user input                                   
      attribute :declared_currency, String # user input                                                                              
      attribute :declared_value, Float # user input 
      
      attribute :pieces, Array
      
      def calculate_attributes
        calculate_pieces
        calculate_country_name
        calculate_currency
        unless shipment_details_date
          shipment_details_date = Date.today
        end
      end                                                                                   
      
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
        
        def calculate_currency
          if self.shipper_countrycode
            self.shipment_details_currencyCode = CURRENCY_CODES[self.shipper_countrycode]
          end
        end
        
        def calculate_country_name
          if self.shipper_countrycode
            self.shipper_countryname = COUNTRIES[self.shipper_countrycode.to_sym]
          end  

          if self.consignee_countrycode
            self.consignee_countryname = COUNTRIES[self.consignee_countrycode.to_sym]
          end  
        end
        
        def calculate_pieces
          if pieces
            number_pieces, weight = 0, 0
            pieces.each do |piece|
              if piece.quantity
                number_pieces += piece.quantity 
                weight += piece.weight * piece.quantity if piece.weight
              else
                number_pieces += 1
                weight += piece.weight * 1 if piece.weight
              end            
            end
            self.shipment_details_weight = weight
            self.shipment_details_number_of_pieces = number_pieces
          end
        end
    end
  end
end