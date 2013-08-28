require 'virtus'

module ActiveMerchant
  module Shipping
    
    class FedexPackage
      include Virtus
      
      attribute :quantity, Integer      
      attribute :height, Integer
      attribute :width, Integer
      attribute :length, Integer      
      attribute :weight, Float  
    end
  end
end