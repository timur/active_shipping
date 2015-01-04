require 'test_helper'
require 'nokogiri'

class UpsParseShipmentResponseTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_parse_multiple_images
    xml_string_cofirm = File.read(Dir.pwd + "/test/fixtures/xml/ups/multiple_labels_confirm.xml")
    xml_confirm = Nokogiri::XML(xml_string_cofirm)

    xml_string_accept = File.read(Dir.pwd + "/test/fixtures/xml/ups/multiple_labels_accept.xml")
    xml_accept = Nokogiri::XML(xml_string_accept)
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)

    response = ups.parse_accept_response(xml_accept, ActiveMerchant::Shipping::UpsShipment.new)    
    
    assert response.success == true
        
    assert response.packages.size == 4
    assert response.packages.first.tracking_number == "1Z0VR8930492694390"
    assert response.packages[1].tracking_number == "1Z0VR8930490973403"        
  end  
end
