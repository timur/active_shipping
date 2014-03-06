# encoding: utf-8
require_relative '../test_helper'

class FedExPickupTest < Test::Unit::TestCase

  def setup
  end    
  
  def test_pickup_raw
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(raw_xml: "pickup_raw.xml")    
    
    save_xml(response, "test_pickup_raw")
    assert_not_nil response
  end      

end