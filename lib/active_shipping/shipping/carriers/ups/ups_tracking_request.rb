require 'virtus'
require 'erb'


module ActiveMerchant
  module Shipping
    
    class UpsTrackingRequest
      include Virtus.model

      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :trackingnumber, String      
      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
            
      private
      
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/tracking.xml.erb"
        end
      
    end
  end
end
