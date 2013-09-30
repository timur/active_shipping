require 'virtus'

module ActiveMerchant
  module Shipping
    
    class UpsPackage
      include Virtus
      
      attribute :height, Integer
      attribute :width, Integer
      attribute :length, Integer      
      attribute :weight, Float  
    end
  end
end
