require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlModifyPickupRequest
      include Virtus.model
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :site_id, String
      attribute :password, String      

      attribute :account_number, String 
      attribute :origin_area, String            
      attribute :confirmation_number, String      
      attribute :business, Boolean, default: false
      attribute :company, String                  
      attribute :address, String
      attribute :package_location, String
      attribute :city, String
      attribute :country, String
      attribute :postal_code, String
      
      attribute :pickup_date, Date     
      attribute :ready_by_time, String
      attribute :close_time, String     
            
      attribute :contact_name, String           
      attribute :contact_phone, String 
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      def is_business_address
        business
      end
      
      def location_type
        back = "R"
        back = "B" if is_business_address
        back
      end
            
      def pickup_date
        date = Date.parse(pickup_date.to_s)
        date.strftime("%Y-%m-%d")
      end   
                  
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/dhl/templates/modify_pickup.xml.erb"
        end
    end
  end
end