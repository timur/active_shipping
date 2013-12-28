# encoding: utf-8
require_relative '../test_helper'

class FedExShipmentTest < Test::Unit::TestCase

  def setup
  end
    
  def test_shipment_mexico
    package = ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::FedexShipmentRequest.new(
      service_type: "STANDARD_OVERNIGHT",      
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      recipient_countrycode: "MX",        
      recipient_postalcode: "11510",
      contact_shipper_fullname: "John Shipper",
      contact_recipient_fullname: "Klaus Receiver",
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      shipper_city: "Mex City",      
      shipper_address_line: "Address Shipper",      
      contact_shipper_phonenumber: "12345",            
      recipient_countrycode: "MX",        
      recipient_postalcode: "16034",
      recipient_city: "Mex City",     
      recipient_address_line: "Address Recipient",  
      contact_recipient_phonenumber: "12345",         
      packaging_type: "Package",
      package: package       
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)     
    save_xml(response, "test_shipment_mexico_fedex")
    assert response.success == true
    assert_not_nil response
  end
  
  def test_shipment_multiple_raw
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "testcases/test_multiple_raw.xml")     
    save_xml(response, "test_shipment_multiple_raw")
    assert_not_nil response
  end
    
  def test_shipment_declared_value_int
    package = ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::FedexShipmentRequest.new(
      service_type: "FEDEX_GROUND",      
      shipper_countrycode: "US",
      shipper_postalcode: "73301",
      shipper_provincecode: "TX",      
      shipper_city: "Austin",      
      shipper_address_line: "Address Shipper",      
      contact_shipper_fullname: "Hans Dampf",
      contact_shipper_phonenumber: "12345",            
      recipient_countrycode: "CA",        
      recipient_postalcode: "V7C4V4",
      recipient_city: "Richmond",     
      recipient_address_line: "Address Recipient",  
      recipient_provincecode: "BC",     
      contact_recipient_fullname: "Hans Wurst",
      contact_recipient_phonenumber: "12345",   
      declared_currency: "USD",
      declared_value: 430,   
      package: package
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)      
    save_xml(response, "test_shipment_declared_value_int")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end
  
  def test_shipment_sequence
    package = ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::FedexShipmentRequest.new(
      service_type: "FEDEX_GROUND",      
      shipper_countrycode: "US",
      shipper_postalcode: "73301",
      shipper_provincecode: "TX",      
      shipper_city: "Austin",      
      shipper_address_line: "Address Shipper",      
      contact_shipper_fullname: "Hans Dampf",
      contact_shipper_phonenumber: "12345",            
      recipient_countrycode: "CA",        
      recipient_postalcode: "V7C4V4",
      recipient_city: "Richmond",     
      recipient_address_line: "Address Recipient",  
      recipient_provincecode: "BC",     
      contact_recipient_fullname: "Hans Wurst",
      contact_recipient_phonenumber: "12345",   
      declared_currency: "USD",
      declared_value: 430,   
      sequence_number: "1",
      package: package
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)      
    save_xml(response, "test_shipment_sequence")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end  
  
  def test_shipment_insured_value
    package = ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::FedexShipmentRequest.new(
      service_type: "STANDARD_OVERNIGHT",      
      shipper_countrycode: "MX",
      shipper_postalcode: "16034",
      shipper_city: "Mex City",      
      shipper_address_line: "Address Shipper",      
      contact_shipper_fullname: "Hans Dampf",
      contact_shipper_phonenumber: "12345",            
      recipient_countrycode: "MX",        
      recipient_postalcode: "16034",
      recipient_city: "Mex City",     
      recipient_address_line: "Address Recipient",  
      contact_recipient_fullname: "Hans Wurst",
      contact_recipient_phonenumber: "12345",   
      insured_currency: "NMP",
      insured_value: 430,   
      package: package
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)      
    save_xml(response, "test_shipment_insured_value")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end  

  def test_shipment_declared_value_int_raw_xml
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_int.xml")     
    save_xml(response, "test_shipment_declared_value_int_raw_xml")
    assert_not_nil response
  end    

  def test_shipment_declared_value_int_raw_xml_error
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_int_error.xml")     
    save_xml(response, "test_shipment_declared_value_int_raw_error_xml")
    assert_not_nil response
  end 
  
  def test_shipment_insured_value_raw_xml
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_insured_value.xml")     
    save_xml(response, "test_shipment_insured_value_raw_xml")
    assert_not_nil response
  end     

  def test_shipment_declared_value_document_int_raw_xml
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_document_int.xml")     
    save_xml(response, "test_shipment_declared_value_document_int_raw_xml")
    assert_not_nil response
  end     

  def test_shipment_reference_number_raw_xml
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_reference_number.xml")     
    save_xml(response, "test_shipment_reference_number_raw_xml")
    assert_not_nil response
  end 
  
  def test_debug_error
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "error.xml")     
    save_xml(response, "error_xml")
    assert_not_nil response
  end      
  
end