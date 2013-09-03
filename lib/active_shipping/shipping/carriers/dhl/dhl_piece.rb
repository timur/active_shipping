require 'virtus'

module ActiveMerchant
  module Shipping
    
    class DhlPiece
      include Virtus
      
      attribute :piece_id, Integer
      attribute :quantity, Integer      
      attribute :height, Integer
      attribute :width, Integer
      attribute :depth, Integer
      attribute :weight, Float  
      attribute :piece_content, String
    end
  end
end
