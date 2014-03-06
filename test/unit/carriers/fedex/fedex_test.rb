require 'test_helper'

class FedExTest < Test::Unit::TestCase
  def setup
  end
  
  def test_quote_xml
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 3, height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::FedexPackage.new(height: 20, width: 20, length: 20, weight: 2.5)        
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 20, width: 20, length: 20, weight: 2.5)            
    
    request = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      packages: packages
    )
    request.calculate_attributes    

    assert_not_nil request.to_xml
  end  
  
  def test_calculate_pieces
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 3, height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::FedexPackage.new(height: 20, width: 20, length: 20, weight: 2.5)        
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 20, width: 20, length: 20, weight: 2.5)            
    
    request = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      packages: packages
    )
    
    request.calculate_attributes
    
    assert request.package_count == 5
  end
  
  def test_failure
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/fedex_failure.xml")
    xml = Nokogiri::XML(xml_string)
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.parse_quote_response(xml)
    
    assert response.notes.size == 1
    assert response.notes[0].severity == "FAILURE"    
    assert response.success == false    
  end
end
