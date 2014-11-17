require 'virtus'
require 'time'

module ActiveMerchant
  module Shipping
    
    class DhlNote
      include Virtus.model
      
      attribute :code, String
      attribute :data, String
    end

    class DhlExtraCharge
      include Virtus.model
      
      attribute :special_service_type, String
      attribute :local_service_type, String
      attribute :global_service_name, String      
      attribute :local_service_name, String            
      attribute :currency, String             
      attribute :charge_value, Float
      attribute :charge_tax_amount, Float                 
                              
    end    

    class DhlQuote
      include Virtus.model 
      
      attribute :global_product_code, String
      attribute :local_product_code, String           
      attribute :local_product_name, String           
      attribute :product_short_name, String           
      attribute :pickup_date, Date
      attribute :pricing_date, Date      
      attribute :total_charge, Float
      attribute :base_charge, Float      
      attribute :weight_charge, Float            
      attribute :weight_charge_tax, Float                  
      attribute :total_tax_amount, Float
      attribute :tax_percent, Float     
      attribute :discount, Float 
      attribute :surcharge, Float
      attribute :delivery_date, String      
      attribute :delivery_time, String              
      attribute :delivery_date_calculated, DateTime
      attribute :pickup_day_of_week, Integer                    
      attribute :destination_day_of_week, Integer                          
      attribute :pickup_date_cutoff_time, String
      attribute :booking_time, String                        
      attribute :currency, String                              
      attribute :exchange_rate, Float
      attribute :transit_days, Integer 
      attribute :extra_charges, Array 
      
      def calculate
        self.surcharge = 0

        extra_charges.each do |extra|
          if extra.global_service_name == "Discount"
            self.discount = extra.charge_value if extra && extra.charge_value            
          else
            self.surcharge += extra.charge_value if extra && extra.charge_value            
          end
        end
                
        if self.delivery_time
          d = Time.parse(self.delivery_time)
          if d
            s = "#{self.delivery_date} #{d.hour}:#{d.min}"
            s += " UTC"
            self.delivery_date_calculated = Time.parse(s)
          end
        end
      end                                  
    end
                
    class DhlQuoteResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :quotes, Array
      attribute :request, String
      attribute :response, String      
      
    end
  end
end