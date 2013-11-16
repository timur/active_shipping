require 'test_helper'
require 'rexml/document'

class DhlParseTracking < Test::Unit::TestCase
  
  def setup
  end
  
  def test_parse_quote_response
    f = File.open(MODEL_FIXTURES + "xml/dhl/track_response.xml")
    doc = Nokogiri::XML(f)
    f.close
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_tracking_response(doc)
    
    assert response.class.to_s, ActiveMerchant::Shipping::DhlTrackingResponse.class.to_s     
    assert_equal response.success, true
    assert_equal response.tracking_events.size, 13
    assert_equal response.origin_service_area_code, "HKG"
    assert_equal response.origin_description, "HONG KONG - HONG KONG"
    assert_equal response.destination_service_area_code, "LEH"
    assert_equal response.consignee_city, "EURE"    
    
    assert_equal response.tracking_events[0].event_code, "PU"        
    assert_equal response.tracking_events[0].date.class.to_s, "Date"            

  end
end