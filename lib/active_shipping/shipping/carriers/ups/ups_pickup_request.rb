require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
        
    class UpsPickupRequest
      include Virtus.model
      
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::UpsConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :ready_time, String
      attribute :close_time, String
      attribute :pickup_date, String      
      
      attribute :pickup_address_company, String            
      attribute :pickup_address_contact, String                  
      attribute :pickup_address_address, String                  
      attribute :pickup_address_city, String                  
      attribute :pickup_address_postalcode, String                  
      attribute :pickup_address_country_code, String                  
      attribute :pickup_address_phone, String                  

      attribute :instructions, String      
      
      attribute :weight, Float            
      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/pickup.xml.erb"
        end
    end
  end
end