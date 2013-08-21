require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexNote
      include Virtus
      
      attribute :severity, String
      attribute :code, String
      attribute :source, String      
      attribute :message, String      
    end
                
  end
end