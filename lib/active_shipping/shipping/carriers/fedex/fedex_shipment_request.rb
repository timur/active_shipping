require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexShipmentRequest
      include Virtus.model
      include ActiveModel::Validations    
            
      include ActiveMerchant::Shipping::Constants                       
      
      attribute :key, String
      attribute :password, String
      attribute :accountNumber, String      
      attribute :meterNumber, String

      attribute :transactionId, String
      attribute :packaging_type, String, default: "YOUR_PACKAGING"
      attribute :service_type, String            
      attribute :preferred_currency, String            
      attribute :description, String         
      attribute :insured_value, Float
      attribute :insured_currency, String
      attribute :declared_value, Float
      attribute :declared_currency, String
      
      attribute :contact_shipper_fullname, String                  
      attribute :contact_shipper_company, String 
      attribute :contact_shipper_phonenumber, String
      attribute :contact_shipper_phonenumber_ext, String
      
      attribute :shipper_address_line, String # user input                                    
      attribute :shipper_city, String # user input                                 
      attribute :shipper_postalcode, String # user input                           
      attribute :shipper_countrycode, String # user input                    
      attribute :shipper_provincecode, String # user input                          

      attribute :contact_recipient_fullname, String                  
      attribute :contact_recipient_company, String 
      attribute :contact_recipient_phonenumber, String
      attribute :contact_recipient_phonenumber_ext, String
      
      attribute :recipient_address_line, String # user input                                    
      attribute :recipient_city, String # user input                                 
      attribute :recipient_postalcode, String # user input                           
      attribute :recipient_countrycode, String # user input
      attribute :recipient_provincecode, String # user input     
      
      attribute :first_package, Boolean, default: false # user input                       
      
      attribute :sequence_number, String  
      attribute :master_tracking_id, String            
      attribute :tracking_id_type, String                  
      attribute :form_id, String    
      
      attribute :reference, String                              

      attribute :package, FedexPackage
      attribute :package_count, Integer, default: 0
      
      attribute :envelope, Boolean, default: false            
      
      attribute :weight, Float
      attribute :total_weight, Float                  
      attribute :document_weight, Float               
                             
      def calculate_attributes
        if envelope
          self.package_count = 1
                    
          unless self.declared_value.blank?
            unless self.insured_value.blank?
              if self.insured_value > self.declared_value
                self.insured_value = self.declared_value
              end
            end
          end
        end        
      end
      
      def declared?
        if @declared_value.blank?
          return false
        end
      
        if @declared_currency.blank?
          return false
        end
      
        return true
      end      
      
      def international?
        @recipient_countrycode != "MX"
      end
                
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
            
      private
      
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/fedex/templates/shipment.xml.erb"
        end
    end
  end
end