# encoding: utf-8
require_relative '../test_helper'

class UpsShipConfirmTest < Test::Unit::TestCase

  def setup
  end
  
  def test_shipment_confirm_mexico_ups
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::UpsShipmentRequest.new(
      account_number: "0VR893",
      product_code: "65", 
      shipper_number: "0VR893", 
      shipper_name: "Shipper Name", 
      shipper_phone: "1234567890", 
      shipper_address: "Kepler 195", 
      shipper_city: "México DF", 
      shipper_postal_code: "11590",
      shipper_country: "MX",
      ship_to_company: "Company",
      ship_to_name: "Ship To Attn Name",
      ship_to_phone: "97225377171",
      ship_to_address: "Kepler 195",
      ship_to_city: "México DF",
      ship_to_postal_code: "11590",                                                                   
      ship_to_country: "MX",  
      
      ship_from_company: "Company",
      ship_from_name: "Ship To Attn Name",
      ship_from_phone: "97225377171",
      ship_from_address: "Kepler 195",
      ship_from_city: "México DF",
      ship_from_postal_code: "11590",                                                                   
      ship_from_country: "MX",                                                                       

      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
        
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: true)
    response = ups.ship_confirm(request: shipment)    
    
    save_xml(response, "test_shipment_confirm_mexico_ups")
    
    assert_not_nil response    
    assert_not_nil response.digest
    
    ap response.success
  end  
      
  def test_shipment_confirm_raw    
    ups = UPS.new(test: true)
    response = ups.ship_confirm(raw_xml: "testcases/ship_confirm_static.xml", test: true)    
    
    save_xml(response, "test_shipment_confirm_raw")
    assert_not_nil response
  end
  
  def test_shipment_accept_raw    
    ups = UPS.new(test: true)
    response = ups.ship_accept(raw_xml: "testcases/ship_accept_static.xml", test: true)    
    
    save_xml(response, "test_shipment_accept_raw")
    assert_not_nil response
  end      
  
end