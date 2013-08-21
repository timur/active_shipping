require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexQuote
      include Virtus 
      
      attribute :product_name, String           
      attribute :delivery_time, String              
      attribute :day_of_week, String      
      attribute :total_base_charge, Float
      attribute :total_net_charge, Float      
      attribute :total_net_fedex_charge, Float
      attribute :total_surcharge, Float
      attribute :total_tax, Float
      attribute :currency, Float
      attribute :surcharges, Array
      attribute :taxes, Array      
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