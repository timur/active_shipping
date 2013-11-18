# encoding: utf-8
require_relative '../test_helper'

class DhlBookingTest < Test::Unit::TestCase

  def setup
  end
      
  def test_booking_raw    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6')
    response = dhl.book_pickup(raw_xml: "testcases/test_book_pickup_valid_dhl.xml", test: true)    
    
    save_xml(response, "test_book_pickup_raw_dhl")
    assert_not_nil response
  end    
end
