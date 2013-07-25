module ActiveMerchant
  module Shipping
    class Shipper

      attr_reader :contact, :address

      def initialize(options = {})
        @contact = options[:contact]
        @address = options[:address]
      end
      
      def fedex_xml
        xml = XmlNode.new('Shipper') do |shipper|
          shipper << contact.fedex_xml
          shipper << address.fedex_xml                            
        end
        xml
      end
      
    end
  end
end