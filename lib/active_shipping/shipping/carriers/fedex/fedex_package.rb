require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexPackage
      include Virtus.model
      
      attribute :quantity, Integer      
      attribute :height, Integer
      attribute :width, Integer
      attribute :length, Integer      
      attribute :weight, Float  
      
      attribute :reference, String        
    end
  end
end
