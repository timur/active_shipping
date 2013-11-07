require 'test_helper'
require 'nokogiri'

class FedExParseQuoteResponseTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_parse_quote_response
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/response_quote_mexico.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.parse_quote_response(xml)
    
    assert response.notes.size == 1
    assert response.quotes.size == 4      
    assert response.quotes[0].extra_charges.size == 2                
    assert response.quotes[0].currency == "MXN"        
    assert response.quotes[0].taxes == 48.22  
    
    assert response.quotes[0].base_charge == 274.0       
    assert response.quotes[0].surcharge == 27.4    
  end
  
  def test_quote_error
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/quote_error.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.parse_quote_response(xml)
    
    assert response.notes.size == 2
    assert response.success == false
    assert response.notes[0].severity == "ERROR"
    assert response.notes[0].message == "Destination postal code is not serviced."    
    assert response.notes[1].severity == "WARNING"   
    assert response.notes[1].message == "There are no valid services available."             
  end
  
  def test_quote_error_note
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/fedex_quote_error.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.parse_quote_response(xml)
    
    assert response.notes.size == 1
    assert response.success == false
    assert response.notes[0].severity == "ERROR"
    assert response.notes[0].message == "Package 1 - Group package count must be at least a value of 1."    
  end
  
  def test_quote_warning_note
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/fedex_quote_messages.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    
    response = fedex.parse_quote_response(xml)

    assert response.quotes.size == 2   
    assert response.quotes[0].taxes == 39.98  
    
    assert response.notes.size == 1
    assert response.success == true
    assert response.notes[0].severity == "WARNING"
    assert response.notes[0].message == "\n          Rating is temporarily unavailable for one or more services:\n          STANDARD_OVERNIGHT; FEDEX_EXPRESS_SAVER; ; ; ; ; ; ; ; ; . Please try\n          again later. \n        "
  end         
end
