module ActiveMerchant
  module Shipping
    class ShippingRecipient

      attr_reader :contact, :address

      def initialize(options = {})
        @contact = options[:contact]
        @address = options[:address]
      end
      
      def fedex_xml
        xml = XmlNode.new('Recipient') do |recipient|
          recipient << contact.fedex_xml
          recipient << address.fedex_xml                            
        end
        xml
      end
      
    end
  end
end