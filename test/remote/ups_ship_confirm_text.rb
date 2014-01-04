# encoding: utf-8
require_relative '../test_helper'

class UpsShipConfirmTest < Test::Unit::TestCase

  def setup
  end
      
  def test_shipment_confirm_raw    
    ups = UPS.new(test: true)
    response = ups.ship_confirm(raw_xml: "testcases/ship_confirm_static.xml", test: true)    
    
    save_xml(response, "test_shipment_confirm_raw")
    assert_not_nil response
  end    
  
end