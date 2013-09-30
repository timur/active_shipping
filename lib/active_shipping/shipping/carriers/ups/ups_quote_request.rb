require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
        
    class UpsQuoteRequest
      include Virtus
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::UpsConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :package_type, String, default: UpsConstants::PACKAGE
      
      # Pickup 
      attribute :pickup_type, String, default: UpsConstants::DAILY_PICKUP
      
      attribute :shipper_number, String

      attribute :customer_classification, String, default: UpsConstants::CLASSIFICATION_DAILY_RATES
      
      attribute :origin_country_code, String      
      attribute :origin_postal_code, String 
      
      validates :origin_country_code, presence: { message: "(origin_country_code) can't be blank" }
      validates :origin_postal_code, presence: { message: "(origin_postal_code) can't be blank" }      
      
      attribute :destination_country_code, String      
      attribute :destination_postal_code, String            

      validates :destination_country_code, presence: { message: "(destination_country_code) can't be blank" }
      validates :destination_postal_code, presence: { message: "(destination_postal_code) can't be blank" }      
      
      attribute :declared_value, String      
      attribute :declared_currency, String            

      attribute :insured_value, String      
      attribute :insured_currency, String            

      attribute :packages, Array                  
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      def dutiable?
        declared_currency && declared_value
      end
      
      def insured?
        insured_currency && insured_value
      end
            
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/quote.xml.erb"
        end
    end
  end
end