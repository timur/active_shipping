# encoding: utf-8
require_relative '../test_helper'

class DhlTrackingTest < Test::Unit::TestCase

  def setup
  end
      
  def test_tracking_raw    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.tracking(raw_xml: "testcases/track_valid_dhl.xml")    
    
    save_xml(response, "test_tracking_raw_dhl")
    assert_not_nil response
  end    
  
  def test_tracking_amazon
    track_request = ActiveMerchant::Shipping::DhlTrackingRequest.new(
      trackingnumber: "JJD000390003207576932"
    )
     
    dhl = Dhl.new(site_id: 'ZURICATA', password: 'Rln8_VCH3r', test: false)
    response = dhl.tracking(request: track_request)    
    
    save_xml(response, "test_tracking_amazon")    
    assert_not_nil response    
  end  
  
  def test_tracking
    track_request = ActiveMerchant::Shipping::DhlTrackingRequest.new(
      trackingnumber: "8564385550"
    )
     
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.tracking(request: track_request)    
    
    save_xml(response, "test_tracking_dhl")
    
    #assert response.success == true
    #response.tracking_number_unique_identifier == "2456602000~578977864591~FX"
    #response.tracking_events[18].event_type == "OC"
    #response.tracking_events[17].city == "TSUEN WAN"    
    #response.tracking_events[17].postal_code == "230"        
    #response.tracking_events[17].country_code == "HK"            
    assert_not_nil response
  end  
end