require 'test_helper'
require 'nokogiri'

class ResponseQuoteTest < Test::Unit::TestCase
  
  def test_notes
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/dhl/response_quote.xml")
    xml = Nokogiri::XML(xml_string)
    response = DhlQuoteResponse.new
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)

    messages = dhl.send(:parse_notes, response, xml)
    assert response.notes.size == 1
    
    response.notes.each do |message|
      assert message.class == ActiveMerchant::Shipping::DhlNote
    end
    
    assert response.notes[0].code == "3024"
    assert response.notes[0].data == "Postcode format wrong."    
    #assert response.success == true
  end
  
  def test_charge
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/dhl/response_quote_dhl.xml")
    xml = Nokogiri::XML(xml_string)
    response = DhlQuoteResponse.new
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_quote_response(xml)
    
    response.quotes.each do |quote|
      assert quote.class == ActiveMerchant::Shipping::DhlQuote
      if quote.global_product_code == "N"
        assert quote.weight_charge == 84.83
        assert quote.extra_charges.size == 1
        assert quote.extra_charges.first.charge_value == 4.24
      end
    end
    
  end    
end