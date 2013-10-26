require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlNote
      include Virtus.model
      
      attribute :code, String
      attribute :data, String
      attribute :action_code, String      
    end
                
  end
end