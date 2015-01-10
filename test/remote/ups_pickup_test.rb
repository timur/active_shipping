# encoding: utf-8
require_relative '../test_helper'

class UPSPickupTest < Test::Unit::TestCase

  def setup
  end
  
  def test_pickup_raw_ups_prod
    ups = UPS.new(test: false)
    response = ups.pickup(raw_xml: "ups_pickup_raw.xml", test: false)    
    
    save_xml(response, "test_pickup_raw_ups_prod")
    assert_not_nil response    
    
    assert response.success == true
    assert response.pickup_confirmation_number != nil     

  end
end
