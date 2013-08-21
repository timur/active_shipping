require 'active_shipping/shipping/carriers/ups'
require 'active_shipping/shipping/carriers/fedex'
require 'active_shipping/shipping/carriers/dhl'

module ActiveMerchant
  module Shipping
    module Carriers
      class << self
        def all
          [UPS, FedEx, DHL]
        end
      end
    end
  end
end