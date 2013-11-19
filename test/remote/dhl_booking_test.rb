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
  
  def test_booking
    next_monday = 
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6')    
    
    pickup = ActiveMerchant::Shipping::DhlBookPickupRequest.new(
      account_number: 980526857,
      country: "MX",
      pickup_date: date_of_next("Monday"),
      ready_by_time: "09:00",
      close_time: "12:00",  
      weight: 4,
      contact_name: "John Doe",
      contact_phone: "1151sda",
      city: "City",
      postal_code: "11510",
      package_location: "Hinter der Tür",
      address: "citystreet 22"        
    )
    
    response = dhl.book_pickup(test: true, request: pickup)   
    
    assert response.success == true
    assert response.confirmation_number != nil     
    
    save_xml(response, "test_book_pickup_dhl")
    assert_not_nil response
  end
  
  def test_booking_wrong_postalcode
    next_monday = 
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6')    
    
    pickup = ActiveMerchant::Shipping::DhlBookPickupRequest.new(
      account_number: 980526857,
      country: "MX",
      pickup_date: date_of_next("Monday"),
      ready_by_time: "09:00",
      close_time: "12:00",  
      weight: 4,
      contact_name: "John Doe",
      contact_phone: "1151sda",
      city: "City",
      postal_code: "323233",
      package_location: "Hinter der Tür",
      address: "citystreet 22"        
    )
    
    response = dhl.book_pickup(test: true, request: pickup)    
    
    assert response.success == false    
    assert response.error_messages.size > 0
    
    save_xml(response, "test_book_pickup_wrong_dhl")
    assert_not_nil response
  end        
end
