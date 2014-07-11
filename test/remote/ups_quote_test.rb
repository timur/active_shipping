# encoding: utf-8
require_relative '../test_helper'

class UPSTest < Test::Unit::TestCase

  def setup
  end
  
  def test_quote_raw_ups_prod
    ups = UPS.new(test: false)
    response = ups.find_quotes(raw_xml: "testcases/quote_raw_prod.xml", test: false)    
    
    save_xml(response, "test_quote_raw_ups_prod")
    assert_not_nil response    
  end

  def test_quote_raw_ups    
    ups = UPS.new(test: true)
    #response = ups.find_quotes(raw_xml: "testcases/request_test.xml", test: true)    
    response = ups.find_quotes(raw_xml: "testcases/quote_raw_test.xml", test: true)        
    
    save_xml(response, "test_quote_raw_ups")
    assert_not_nil response
  end

  def test_quote_raw_ups_document   
    ups = UPS.new(test: true)
    response = ups.find_quotes(raw_xml: "testcases/quote_raw_document.xml", test: true)    
    
    save_xml(response, "test_quote_raw_ups_document")
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
      shipper_number: "0VR893",
      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_ups")
    assert_not_nil response
  end
  
  def test_quote_international_germany
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "DE", 
      origin_postal_code: "11510", 
      destination_postal_code: "53859",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_international_germany")
    assert_not_nil response
  end
  
  def test_quote_international_us
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "10036-6518",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_international_us")
    assert_not_nil response
  end    
  
  def test_quote_mexico_usa_ups_declared
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "33434",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      declared_currency: "USD",
      declared_value: 100.00,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_ups_declared")
    assert_not_nil response
  end  
  
  def test_quote_mexico_usa_ups_insured
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "33434",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      insured_currency: "NMP",
      insured_value: 100.00,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_ups_insured")
    assert_not_nil response
  end 
  
  def test_quote_mexico_usa_ups_insured_500
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "33434",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      insured_currency: "NNP",
      insured_value: 500.00,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_ups_insured_500")
    assert_not_nil response
  end   

  def test_quote_mexico_usa_ups_declared_document
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "33434",
      shipper_number: "0VR893",      
      package_type: UpsConstants::DOCUMENT,
      declared_currency: "USD",
      declared_value: 100.00,
      envelope: true,
      document_weight: 0.4
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_ups_declared_document")
    assert_not_nil response
  end  
  
  def test_quote_mexico_usa_ups_insured_document
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "33434",
      shipper_number: "0VR893",      
      package_type: UpsConstants::DOCUMENT,
      insured_currency: "USD",
      insured_value: 100.00,
      envelope: true,
      document_weight: 0.4
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_ups_insured_document")
    assert_not_nil response
  end  
  
  def test_quote_mexico_multiple_ups
    packages = []
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::UpsPackage.new(height: 10, width: 10, length: 10, weight: 1.5)        
    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      shipper_number: "0VR893",      
      package_type: UpsConstants::PACKAGE,
      packages: packages       
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_multiple_ups")
    assert_not_nil response
  end    

  def test_quote_mexico_document_ups    
    quote = ActiveMerchant::Shipping::UpsQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      shipper_number: "0VR893",      
      package_type: UpsConstants::DOCUMENT,
      envelope: true,
      document_weight: 0.4,
      pickup_type: UpsConstants::DAILY_PICKUP,
      customer_classification: UpsConstants::CLASSIFICATION_DAILY_RATES,
    )
    
    ups = UPS.new(access_license_number: 'BCBDB1BD667FDBFA', password: 'Shipper7', user_id: 'svencrone', test: true)
    response = ups.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_document_ups")
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
      shipper_number: "0VR893",      
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
