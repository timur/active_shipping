require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexQuote
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
      
    end

    class FedexSurcharge
      include Virtus.model

      attribute :surcharge_type, String                 
      attribute :description, String           
      attribute :amount, Float              
    end

    class FedexTax
      include Virtus.model
      
      attribute :tax_type, String
      attribute :description, String           
      attribute :amount, Float              
    end
                
    class FedexQuoteResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :quotes, Array
      attribute :request, String
      attribute :response, String      
      
      def to_s
        "Success: #{success} | Notes: #{notes.to_s}"
      end
    end
  end
end