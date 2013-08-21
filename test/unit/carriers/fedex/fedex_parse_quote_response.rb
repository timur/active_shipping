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
    assert response.quotes[0].taxes.size == 1        
    assert response.quotes[0].surcharges.size == 2            
    assert response.quotes[0].day_of_week == "WED"    
    assert response.quotes[0].currency == "NMP"        
    assert response.quotes[0].total_tax == 48.22   
    assert response.quotes[0].total_base_charge == 274.0       
    assert response.quotes[0].total_surcharge == 27.4    
    assert response.quotes[0].total_net_fedex_charge == 301.4        

    assert response.quotes[1].taxes.size == 1        
    assert response.quotes[1].surcharges.size == 2            

    assert response.quotes[3].taxes.size == 1        
    assert response.quotes[3].surcharges.size == 2            

    assert response.quotes[3].total_net_fedex_charge == 97.65    
  end    
end
