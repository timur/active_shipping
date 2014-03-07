require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
        
    class UpsShipmentConfirmRequest
      include Virtus.model
      
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::UpsConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :digest, String
      attribute :customer_context, String                  
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/ship_accept.xml.erb"
        end
    end
  end
end