require 'virtus'

module ActiveMerchant
  module Shipping
    
    class UpsNote
      include Virtus.model
      
      attribute :severity, String
      attribute :message, String      
      attribute :code, String            
    end
                
  end
end