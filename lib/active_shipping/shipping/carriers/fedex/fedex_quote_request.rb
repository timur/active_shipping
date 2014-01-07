require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexQuoteRequest
      include Virtus.model
      include ActiveMerchant::Shipping::Constants                       
      
      attribute :key, String
      attribute :password, String
      attribute :accountNumber, String      
      attribute :meterNumber, String

      attribute :transactionId, String
      attribute :packaging_type, String, default: "YOUR_PACKAGING"      
      attribute :preferred_currency, String            
      attribute :insured_value, Float
      attribute :insured_currency, String
      
      attribute :envelope, Boolean, default: false
      
      attribute :shipper_postalcode, String # user input                           
      attribute :shipper_countrycode, String # user input                    

      attribute :recipient_postalcode, String # user input                           
      attribute :recipient_countrycode, String # user input     

      attribute :packages, Array     
      attribute :package_count, Integer
      
      attribute :weight, Float
      attribute :document_weight, Float                                 
                             
      def calculate_attributes
        calculate_pieces
        
        unless packaging_type
          self.packaging_type = "YOUR_PACKAGING"
        end        
        
        if shipper_countrycode
          self.preferred_currency = CURRENCY_CODES[shipper_countrycode]
          if self.preferred_currency == "MXN"
            self.preferred_currency = "NMP"
          end
        end
      end
                
      def to_xml
        if xml_template_path
          ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
        end
      end      
            
      private
      
        def calculate_pieces
          if packages
            number_packages, weight = 0, 0
            packages.each do |package|
              if package.quantity
                number_packages += package.quantity 
                weight += package.weight * package.quantity if package.weight
              else
                number_packages += 1
                weight += package.weight * 1 if package.weight
              end            
            end
            self.weight = weight
            self.package_count = number_packages
          end
        end
        
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/fedex/templates/quote.xml.erb"
        end
    end
  end
end