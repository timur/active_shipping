require 'virtus'

module ActiveMerchant
  module Shipping

    class DhlCancelPickupResponse
      include Virtus.model
    
      attribute :success, Boolean

      attribute :request, String
      attribute :response, String
      
      attribute :error_messages, Array            
    end
  end
end