require 'virtus'

module ActiveMerchant
  module Shipping
    
    class UpsTransitSummary
      include Virtus.model
    
      attribute :code, String
      attribute :customer_cutoff, String
      attribute :time, String
      attribute :pickup_time, String
      attribute :date, String
      attribute :pickup_date, String
    end    
                
    class UpsTransitResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :summaries, Array

      attribute :request, String
      attribute :response, String      
      
      def success?
        @success
      end
      
      def to_s
        "Success: #{success}"
      end
    end
  end
end