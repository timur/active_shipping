# encoding: utf-8
require_relative '../test_helper'

class UpsTrackingTest < Test::Unit::TestCase

  def setup
  end
      
  def test_tracking_raw    
    ups = UPS.new(test: true)
    response = ups.tracking(raw_xml: "testcases/track_raw.xml", test: true)    
    
    save_xml(response, "test_tracking_raw_ups")
    assert_not_nil response
  end    
  
  def test_tracking
    track_request = ActiveMerchant::Shipping::UpsTrackingRequest.new(
      trackingnumber: "1Z12345E0291980793"
    )
     
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.tracking(request: track_request, test: true)    
    
    save_xml(response, "test_tracking_ups")
    
    assert response.success == true
    #response.tracking_number_unique_identifier == "2456602000~578977864591~FX"
    #response.tracking_events[18].event_type == "OC"
    #response.tracking_events[17].city == "TSUEN WAN"    
    #response.tracking_events[17].postal_code == "230"        
    #response.tracking_events[17].country_code == "HK"            
    assert_not_nil response
  end
  
  def test_tracking_ups_shoes
    track_request = ActiveMerchant::Shipping::UpsTrackingRequest.new(
      trackingnumber: "1Z95152V6863803543"
    )
     
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: false)
    response = ups.tracking(request: track_request, test: false)    
    
    save_xml(response, "test_tracking_ups_shoes")
    
    assert response.success == true
    assert_not_nil response
  end    
end