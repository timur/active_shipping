# encoding: utf-8
require_relative '../test_helper'

class UPSTest < Test::Unit::TestCase

  def setup
  end

  def test_quote_raw_ups    
    ups = UPS.new(test: true)
    response = ups.find_quotes(raw_xml: "testcases/request_test.xml", test: true)    
    
    save_xml(response, "test_quote_raw_ups")
    assert_not_nil response
  end

  def test_quote_raw_ups_2    
    ups = UPS.new(test: true)
    response = ups.find_quotes(raw_xml: "testcases/quote_raw.xml", test: true)    
    
    save_xml(response, "test_quote_raw_ups_2")
    assert_not_nil response
  end
  
  def test_quote_mexico_ups
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_ups")
    assert_not_nil response
  end  

  def test_quote_mexico_wrong_postcode
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "9999999", 
      destination_postal_code: "9999999",
      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_ups_wrong_postcode")
    assert_not_nil response
  end  
end
