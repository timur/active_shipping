require 'test_helper'
require 'nokogiri'

class ResponseTest < Test::Unit::TestCase
  
  def test_error_shipment_response
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/dhl/response_shipment_error.xml")
    xml = Nokogiri::XML(xml_string)
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)

    response = dhl.parse_shipment_response(xml, {})    
    
    puts response.notes
    
    assert response.is_success? == false    
  end
  
  def test_notes
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/dhl/response_shipment.xml")
    xml = Nokogiri::XML(xml_string)
    response = DhlShipmentResponse.new
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)

    messages = dhl.send(:parse_notes, response, xml)
    assert response.notes.size == 1
    
    response.notes.each do |message|
      assert message.class == ActiveMerchant::Shipping::DhlNote
    end
    
    assert response.notes[0].action_code == "Success"
    assert response.is_success? == true
  end
  
  def test_response
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/dhl/response_shipment.xml")
    xml = Nokogiri::XML(xml_string)
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_shipment_response(xml, {})
    
    assert response.airwaybillnumber == "7742226800"
    assert response.rated == "N"    
    assert response.dimensional_weight == 1.8    
    assert response.chargable_weight == 2.0  
    assert response.customer_id == "300902"          
    assert response.shipper_company == "company"
    assert response.consignee_company == "Company Consignee"        
    assert response.contact_shipper_fullname = "Hans Meier"              
    assert_not_nil response.label
    
    #response.write_label(Dir.pwd + "/test_label.pdf")
  end
  
end