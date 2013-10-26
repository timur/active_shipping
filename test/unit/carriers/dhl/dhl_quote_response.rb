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
    
    puts response.success
    assert response.notes[0].code == "3024"
    assert response.notes[0].data == "Postcode format wrong."    
    #assert response.success == true
  end  
end