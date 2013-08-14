require 'test_helper'

class ResponseTest < Test::Unit::TestCase
  
  def test_notes
    xml_string = File.read(Dir.pwd + "/test/fixtures/xml/fedex/test_rate_insured_response.xml")
    xml = REXML::Document.new(xml_string)
    fedex = FedEx.new(
      key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true
    )
    
    messages = fedex.send(:response_message, xml, 'http://fedex.com/ws/rate/v13')
    assert messages.size == 4
    
    messages.each do |message|
      assert message.class == ActiveMerchant::Shipping::ShippingMessage
    end
  end
end