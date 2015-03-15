require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexBookPickupRequest
      include Virtus.model
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::Constants                       
      
      attribute :key, String
      attribute :password, String
      attribute :accountNumber, String      
      attribute :meterNumber, String
      
      attribute :person_name, String
      attribute :company, String      
      attribute :phone, String            
      
      attribute :address, String                  
      attribute :state, String
      attribute :postalcode, String
      attribute :country, String      
      attribute :package_location, String
      attribute :close_time, String

      attribute :package_count, Integer
      
      attribute :weight, Float            
      attribute :pickup_time, String                  
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
                  
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/fedex/templates/pickup.xml.erb"
        end
    end
  end
end