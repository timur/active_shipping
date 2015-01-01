require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlPiece
      include Virtus.model
      
      attribute :piece_id, Integer
      attribute :quantity, Integer      
      attribute :height, Integer
      attribute :width, Integer
      attribute :depth, Integer
      attribute :weight, Float  
      attribute :dim_weight, Float  
      attribute :piece_content, String
    end
  end
end
