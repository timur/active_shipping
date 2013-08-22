require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexQuote
      include Virtus 
      
      attribute :product_name, String           
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
      include Virtus 

      attribute :surcharge_type, String                 
      attribute :description, String           
      attribute :amount, Float              
    end

    class FedexTax
      include Virtus 
      
      attribute :tax_type, String
      attribute :description, String           
      attribute :amount, Float              
    end
                
    class FedexQuoteResponse
      include Virtus
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :quotes, Array
      attribute :request, String
      attribute :response, String      
      
    end
  end
end