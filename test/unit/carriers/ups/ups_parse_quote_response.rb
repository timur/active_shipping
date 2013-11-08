require 'test_helper'
require 'nokogiri'

class UpsParseQuoteResponseTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_parse_quote_response_ups
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/ups/quote_response_raw.xml")
    xml = Nokogiri::XML(xml_string)
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.parse_quote_response(xml)
    
    assert response.success == true
    assert response.notes.size == 2
    assert response.quotes.size == 3      
        
    assert response.quotes[0].total_charge.to_f == 240.99               
    assert response.quotes[0].currency == "MXN"        
    assert response.quotes[0].surcharge == 0
    assert response.quotes[0].total_charge == 240.99
    assert response.quotes[0].product_code.to_i == 100              
    
    assert response.quotes[2].product_code == "07"                  
    assert response.quotes[2].product_name == "UPS Worldwide Express"
    
  end
  
  #def test_quote_error
  #  xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/quote_error.xml")
  #  xml = Nokogiri::XML(xml_string)
  #  
  #  fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
  #  response = fedex.parse_quote_response(xml)
  #  
  #  assert response.notes.size == 2
  #  assert response.success == false
  #  assert response.notes[0].severity == "ERROR"
  #  assert response.notes[0].message == "Destination postal code is not serviced."    
  #  assert response.notes[1].severity == "WARNING"   
  #  assert response.notes[1].message == "There are no valid services available."             
  #end
  #
  #def test_quote_error_note
  #  xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/fedex_quote_error.xml")
  #  xml = Nokogiri::XML(xml_string)
  #  
  #  fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
  #  response = fedex.parse_quote_response(xml)
  #  
  #  assert response.notes.size == 1
  #  assert response.success == false
  #  assert response.notes[0].severity == "ERROR"
  #  assert response.notes[0].message == "Package 1 - Group package count must be at least a value of 1."    
  #end
  #
  #def test_quote_warning_note
  #  xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/fedex_quote_messages.xml")
  #  xml = Nokogiri::XML(xml_string)
  #  
  #  fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
  #  
  #  response = fedex.parse_quote_response(xml)
  #
  #  assert response.quotes.size == 2   
  #  assert response.quotes[0].taxes == 39.98  
  #  
  #  assert response.notes.size == 1
  #  assert response.success == true
  #  assert response.notes[0].severity == "WARNING"
  #  assert response.notes[0].message == "\n          Rating is temporarily unavailable for one or more services:\n          STANDARD_OVERNIGHT; FEDEX_EXPRESS_SAVER; ; ; ; ; ; ; ; ; . Please try\n          again later. \n        "
  #end         
end
