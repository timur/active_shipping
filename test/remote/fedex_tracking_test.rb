# encoding: utf-8
require_relative '../test_helper'

class FedExTrackingTest < Test::Unit::TestCase

  def setup
  end
      
  def test_tracking_raw    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.tracking(raw_xml: "testcases/track_valid.xml")    
    
    save_xml(response, "test_tracking_raw")
    assert_not_nil response
  end    
  
  def test_tracking
    track_request = ActiveMerchant::Shipping::FedexTrackingRequest.new(
      trackingnumber: "578977864591"
    )
     
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.tracking(request: track_request)    
    
    save_xml(response, "test_tracking")
    
    assert response.tracking_events.size == 19
    assert response.success == true
    response.tracking_number_unique_identifier == "2456602000~578977864591~FX"
    response.tracking_events[18].event_type == "OC"
    response.tracking_events[17].city == "TSUEN WAN"    
    response.tracking_events[17].postal_code == "230"        
    response.tracking_events[17].country_code == "HK"            
    assert_not_nil response
  end  
end


#attribute :timestamp, DateTime
#attribute :event_type, String           
#attribute :event_description, String
#attribute :city, String
#attribute :postal_code, String
#attribute :country_code, String                                
#attribute :residential, Boolean                                      
#attribute :arrival_location, String