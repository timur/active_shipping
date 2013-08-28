# encoding: utf-8
require_relative '../test_helper'

class FedExTrackingTest < Test::Unit::TestCase

  def setup
  end
      
  def test_tracking    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(raw_xml: "testcases/track_valid.xml")    
    
    save_xml(response, "track_valid")
    assert_not_nil response
  end    
end