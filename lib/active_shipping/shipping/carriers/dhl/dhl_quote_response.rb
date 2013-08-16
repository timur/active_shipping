require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlNote
      include Virtus
      
      attribute :code, String
      attribute :data, String
    end

            
    class DhlQuoteResponse
      include Virtus
      
      attribute :notes, Array
      
    end
  end
end