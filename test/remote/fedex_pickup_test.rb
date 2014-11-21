# encoding: utf-8
require_relative '../test_helper'

class FedExPickupTest < Test::Unit::TestCase

  def setup
  end    
  
  def test_pickup_raw
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: false)
    response = fedex.find_quotes(raw_xml: "pickup_raw.xml")    
    
    save_xml(response, "test_pickup_raw")
    assert_not_nil response
  end 
  
  def test_book_pickup_fedex
    fedex = FedEx.new(key: 'THMNl2nJQBc0U41y', password: 'Fj7tkfla7Hpou1JUNTbKSO6aF', accountNumber: '342914012', meterNumber: '106259821', test: false)
    
    pickup = ActiveMerchant::Shipping::FedexBookPickupRequest.new(
      person_name: "Esteban",
      company: "Comcom",
      phone: "12323",
      country: "MX",
      pickup_time: Time.now,      
      weight: nil,
      city: "Mexico DF",
      state: "DF",
      postalcode: "11550",
      address: "Blas Pascal 126",
      package_location: "FRONT",
      close_time: "20:00:00",
      package_count: 1
    )
    
    response = fedex.book_pickup(request: pickup)   
    save_xml(response, "test_book_pickup_fedex")
    
    assert response.success == true
    assert response.pickup_confirmation_number != nil     
    
    assert_not_nil response
  end       

end