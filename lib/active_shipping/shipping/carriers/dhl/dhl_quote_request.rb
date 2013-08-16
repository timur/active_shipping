require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlPiece
      include Virtus
      
      attribute :piece_id, Integer
      attribute :height, Integer
      attribute :width, Integer
      attribute :depth, Integer
      attribute :weight, Float  
    end
        
    
    # dutiable - zollpflichtig
    class DhlQuoteRequest
      
      DIMENSIONS_UNIT_CODES = { centimeters: "CM", inches: "IN" }
      WEIGHT_UNIT_CODES = { kilograms: "KG", pounds: "LB" }      
      
      attr_reader :origin_country_code, 
                  :origin_postal_code, :destination_country_code, 
                  :destination_postal_code, :declared_currency, :declared_value,
                  :payment_account_number, :pieces
                  
      attr_accessor :site_id, :password
      
      def initialize(options = {})
        @site_id = options[:site_id]
        @password = options[:password]
        @origin_country_code = options[:origin_country_code]
        @origin_postal_code = options[:origin_postal_code]
        @destination_country_code = options[:destination_country_code]                                
        @destination_postal_code = options[:destination_postal_code]                                        
        @declared_value = options[:declared_value]                                        
        @declared_currency = options[:declared_currency]
        @pieces = options[:pieces]                                                        
      end
      
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
         
      def dimensions_unit
        DIMENSIONS_UNIT_CODES[:centimeters]        
      end
      
      def weight_unit
        WEIGHT_UNIT_CODES[:kilograms]
      end
      
      def pieces
        []
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