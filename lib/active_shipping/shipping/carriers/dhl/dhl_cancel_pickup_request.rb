require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlCancelPickupRequest
      include Virtus.model
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :site_id, String
      attribute :password, String      

      attribute :confirmation_number, String      
      attribute :origin_area, String            
            
      attribute :requestor, String
      attribute :reason, String                 
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/dhl/templates/cancel_pickup.xml.erb"
        end
    end
  end
end