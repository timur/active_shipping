require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexShipmentRequest
      include Virtus.model
      include ActiveMerchant::Shipping::Constants                       
      
      attribute :key, String
      attribute :password, String
      attribute :accountNumber, String      
      attribute :meterNumber, String

      attribute :transactionId, String
      attribute :packaging_type, String      
      attribute :service_type, String            
      attribute :preferred_currency, String            
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

      attribute :packages, FedexPackage
      attribute :package_count, Integer
      
      attribute :weight, Float                           
                             
      def calculate_attributes
        calculate_package
        unless packaging_type
          self.packaging_type = "YOUR_PACKAGING"
        else
          if packaging_type == "Document"
            self.packaging_type = "FEDEX_ENVELOPE"
          end
        end
                
        if shipper_countrycode
          #self.preferred_currency = CURRENCY_CODES[shipper_countrycode]
        end
      end
                
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
            
      private
      
        def calculate_package
          if package
            number_packages, weight = 0, 0
            if package.quantity
              number_packages += package.quantity 
              weight += package.weight * package.quantity if package.weight
            else
              number_packages += 1
              weight += package.weight * 1 if package.weight
            end            
            self.weight = weight
            self.package_count = number_packages
          end
        end
        
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/fedex/templates/shipment.xml.erb"
        end
    end
  end
end