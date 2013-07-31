module ActiveMerchant
  module Shipping
    
    class ShipResponse < Response
      
      attr_reader :tracking_number, :success, :request, :response
            
      def initialize(success, message, params = {})
        @tracking_number = params[:tracking_number]
        @request = params[:request]
        @response = params[:response]                
        @success = success
        super
      end
      
    end    
  end
end