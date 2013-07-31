module ActiveMerchant
  module Shipping
    
    class ShipResponse < Response
      
      attr_reader :shipment
      
      def initialize(success, message, params = {}, options = {})
        @tracking_number = options[:tracking_number]
        super
      end
      
    end    
  end
end