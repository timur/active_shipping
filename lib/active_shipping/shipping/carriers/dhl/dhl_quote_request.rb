require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    # dutiable - zollpflichtig
    class DhlQuoteRequest
      include Virtus
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :site_id, String
      attribute :password, String      

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
      attribute :pieces, Array                  
                      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      def dutiable?
        declared_currency && declared_value
      end
      
      # ready times are only 8a-5p(17h)
      def ready_time(time = Time.now)
        if time.hour >= 17 || time.hour < 8
          time.strftime("PT08H00M")
        else
          time.strftime("PT%HH%MM")
        end
      end

      # ready dates are only mon-fri
      def ready_date(t = Time.now)
        date = Date.parse(t.to_s)
        if (date.cwday >= 6) || (date.cwday >= 5 && t.hour >= 17)
          date.send(:next_day, 8-date.cwday)
        else
          date
        end.strftime("%Y-%m-%d")
      end   
            
      def special_services
        []
      end
      
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/dhl/templates/quote.xml.erb"
        end
    end
  end
end