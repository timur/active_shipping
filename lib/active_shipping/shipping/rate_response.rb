module ActiveMerchant #:nodoc:
  module Shipping
    
    class RateResponse < Response
      
      attr_reader :rates, :response, :request
      
      def initialize(success, message, params = {})
        @rates = Array(params[:estimates] || params[:rates] || params[:rate_estimates])
        @request = params[:request]
        @response = params[:response]        
        super
      end
      
      alias_method :estimates, :rates
      alias_method :rate_estimates, :rates
      
    end
    
  end
end