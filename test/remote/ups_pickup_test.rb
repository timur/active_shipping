# encoding: utf-8
require_relative '../test_helper'

class UPSPickupTest < Test::Unit::TestCase

  def setup
  end
  
  def test_pickup_raw_ups_prod
    ups = UPS.new(test: false)
    response = ups.find_quotes(raw_xml: "pickup_request_raw2.xml", test: false)    
    
    save_xml(response, "test_pickup_raw_ups_prod")
    assert_not_nil response    
  end


end
