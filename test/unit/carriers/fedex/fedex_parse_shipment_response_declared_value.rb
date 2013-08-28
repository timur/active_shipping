require 'test_helper'
require 'nokogiri'

class FedExParseShipmentResponseDeclaredValueTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_parse_shipment_response_declared_value
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/testcases/ship_declared_value_int_response.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.parse_shipment_response(xml)
    
    assert response.notes.size == 1
    assert response.trackingnumber == "794808790080"
    assert_not_nil response.label
  end    
end
