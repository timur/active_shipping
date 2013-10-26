require 'virtus'

module ActiveMerchant
  module Shipping
    
    class UpsPackage
      include Virtus.model
      
      attribute :height, Integer
      attribute :width, Integer
      attribute :length, Integer      
      attribute :weight, Float  
    end
  end
end
