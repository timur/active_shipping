# encoding: utf-8
require_relative '../test_helper'

class FedExShipmentTest < Test::Unit::TestCase

  def setup
  end
    
  def test_shipment_mexico_fedex
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
      packaging_type: "YOUR_PACKAGING",
      package: package       
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)     
    save_xml(response, "test_shipment_mexico_fedex")
    assert response.success == true
    assert_not_nil response
  end
  
  def test_shipment_mexico_document_fedex
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
      envelope: true,
      document_weight: 0.4
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)     
    save_xml(response, "test_shipment_mexico_document_fedex")
    assert response.success == true
    assert_not_nil response
  end  
  
  def test_shipment_mexico_multiple_fedex
    package = ActiveMerchant::Shipping::FedexPackage.new(quantity: 3, height: 10, width: 10, length: 10, weight: 1.5)
    
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
      sequence_number: "1",  
      recipient_postalcode: "16034",
      recipient_city: "Mex City",     
      recipient_address_line: "Address Recipient",  
      contact_recipient_phonenumber: "12345",         
      packaging_type: "YOUR_PACKAGING",
      first_package: true,
      total_weight: 3.5,
      package: package       
    )
     
    shipment.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(request: shipment)     
    save_xml(response, "test_shipment_mexico_multiple_fedex")
    assert response.success == true
    assert response.master_trackingnumber != ""    
    assert_not_nil response
  end  
  
  def test_shipment_multiple_raw_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "testcases/test_multiple_raw_mex.xml")     
    save_xml(response, "test_shipment_multiple_raw_fedex")
    assert_not_nil response
  end
    
  def test_shipment_declared_value_int_fedex
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
    save_xml(response, "test_shipment_declared_value_int_fedex")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end
  
  def test_shipment_sequence_fedex
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
    save_xml(response, "test_shipment_sequence_fedex")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end  
  
  def test_shipment_insured_value_fedex
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
    save_xml(response, "test_shipment_insured_value_fedex")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end  

  def test_shipment_declared_value_int_raw_xml_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_int.xml")     
    save_xml(response, "test_shipment_declared_value_int_raw_xml_fedex")
    assert_not_nil response
  end    

  def test_shipment_declared_value_int_raw_xml_error_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_int_error.xml")     
    save_xml(response, "test_shipment_declared_value_int_raw_xml_error_fedex")
    assert_not_nil response
  end 

  def test_shipment_error_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/error.xml")     
    save_xml(response, "test_shipment_error_fedex")
    assert_not_nil response
  end 
  
  def test_shipment_insured_value_raw_xml_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_insured_value.xml")     
    save_xml(response, "test_shipment_insured_value_raw_xml_fedex")
    assert_not_nil response
  end     

  def test_shipment_declared_value_document_int_raw_xml_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_declared_value_document_int.xml")     
    save_xml(response, "test_shipment_declared_value_document_int_raw_xml_fedex")
    assert_not_nil response
  end     

  def test_shipment_reference_number_raw_xml_fedex
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "/testcases/ship_reference_number.xml")     
    save_xml(response, "test_shipment_reference_number_raw_xml_fedex")
    assert_not_nil response
  end 
  
  def test_debug_error
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.shipment(raw_xml: "error.xml")     
    save_xml(response, "error_xml")
    assert_not_nil response
  end      
  
end