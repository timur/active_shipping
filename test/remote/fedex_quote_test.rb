# encoding: utf-8
require_relative '../test_helper'

class FedExQuoteTest < Test::Unit::TestCase

  def setup
  end
    
  def test_quote_mexico
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      recipient_countrycode: "MX",        
      recipient_postalcode: "11510",
      packages: packages       
    )
     
    quote.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_fedex")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end
  
  def test_quote_mexico_usa
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      recipient_countrycode: "US",        
      recipient_postalcode: "90210",
      packages: packages       
    )
     
    quote.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_fedex")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end    
  
  def test_quote_static    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(raw_xml: "test_quote_mexico_working.xml")    
    
    save_xml(response, "test_quote_static")
    assert_not_nil response
  end    

  def test_quote_insured_document_raw_xml 
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(raw_xml: "/testcases/quote_insured_value_document.xml")    
    
    save_xml(response, "test_quote_insured_document_raw_xml")
    assert_not_nil response
  end    
  
  def test_quote_insured_document
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, weight: 0.2)

    quote = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      recipient_countrycode: "MX",        
      recipient_postalcode: "11510",
      packaging_type: "Document",
      insured_value: 100,
      insured_currency: "NMP",
      packages: packages       
    )
     
    quote.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_insured_document")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end    
  
  
  def test_quote_insured_raw_xml 
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(raw_xml: "/testcases/quote_insured_value.xml")    
    
    save_xml(response, "test_quote_insured_raw_xml")
    assert_not_nil response
  end    

  def test_quote_insured
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 10, width: 10, length: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      shipper_countrycode: "MX",
      shipper_postalcode: "11510",
      recipient_countrycode: "MX",        
      recipient_postalcode: "11510",
      insured_value: 100,
      insured_currency: "NMP",
      packages: packages       
    )
     
    quote.calculate_attributes
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', accountNumber: '510087267', meterNumber: '118511895', test: true)
    response = fedex.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_insured")
    assert response.notes.size == 1
    assert response.success == true
    assert_not_nil response
  end    
  
end