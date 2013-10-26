require 'virtus'
require 'time'

module ActiveMerchant
  module Shipping
    
    class UpsQuoteResponse
      include Virtus.model
      
      attribute :success, Boolean
      attribute :notes, Array
      attribute :quotes, Array
      attribute :request, String
      attribute :response, String      
      
    end
  end
end