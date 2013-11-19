require 'virtus'

module ActiveMerchant
  module Shipping

    class DhlBookPickupResponse
      include Virtus.model
    
      attribute :success, Boolean

      attribute :request, String
      attribute :response, String
      
      attribute :confirmation_number, String      
      attribute :ready_by_time, Time
      attribute :next_pickup_date, Date      

      attribute :error_messages, Array      
      
    end
  end
end