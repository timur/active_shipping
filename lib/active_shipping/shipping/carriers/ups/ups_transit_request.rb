require 'virtus'
require 'erb'

module ActiveMerchant
  module Shipping
    
    class UpsTransitRequest
      include Virtus.model

      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :postcode_from, String      
      attribute :postcode_to, String            
      
      attribute :country_from, String                  
      attribute :country_to, String                        
      
      attribute :pickup_date, String
      
      attribute :weight, Float                                    
      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
            
      private
      
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/transit.xml.erb"
        end
      
    end
  end
end
