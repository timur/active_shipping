require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlNote
      include Virtus.model
      
      attribute :code, String
      attribute :data, String
      attribute :action_code, String   
      
      def to_s
        "Code: #{code} Data: #{data} ActionCode: #{action_code}"   
      end
    end
                
  end
end