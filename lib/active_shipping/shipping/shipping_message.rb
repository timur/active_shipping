module ActiveMerchant
  module Shipping
    class ShippingMessage

      attr_reader :code, :message, :localized_message, :severity
      
      def initialize(options = {})
        @code = options[:code]
        @message = options[:message]
        @localized_message = options[:localized_message]
        @severity = options[:severity]
      end      
    end
  end
end
