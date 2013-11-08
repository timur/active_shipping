require 'virtus'
require 'time'

module ActiveMerchant
  module Shipping
    
    class UpsQuoteResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :quotes, Array
      attribute :request, String
      attribute :response, String            
    end
    
    class UpsQuote
      include Virtus.model
      
      attribute :product_name, String
      attribute :product_code, String                 
      attribute :delivery_time, String  
      attribute :delivery_date, DateTime                                
      attribute :base_charge, Float
      attribute :total_charge, Float      
      attribute :surcharge, Float
      attribute :taxes, Float
      attribute :tax_rate, Float
      attribute :currency, Float      
      attribute :extra_charges, Array      
      
      def set_product_name
        if self.product_code
          name = UpsConstants::DEFAULT_SERVICES[self.product_code.to_s]
          self.product_name = name if name
        end
      end      
    end    
  end
end