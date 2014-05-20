# encoding: utf-8
require_relative '../test_helper'

class DhlTest < Test::Unit::TestCase

  def setup
  end      
  
  def test_quote_mexico
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      payment_account_number: "988191844",
      pieces: pieces       
    )

    dhl = Dhl.new(site_id: 'ZURICATA', password: 'Rln8_VCH3r', test: false)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_dhl")
    assert_not_nil response
  end

  def test_quote_multiple_packages
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 13, width: 22, depth: 18, weight: 2.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 18, width: 12, depth: 33, weight: 8.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 12, width: 8, depth: 10, weight: 1.2)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      pieces: pieces, 
      package_type: "package"      
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_multiple_packages")
    assert_not_nil response
  end
  
  def test_quote_mexico_usa
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "90210",
      pieces: pieces       
    )
     
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico_usa_dhl")
    assert_not_nil response
  end    

  def test_quote_declared
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "90210",
      pieces: pieces,
      declared_currency: "MXN",
      declared_value: 100       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_declared_dhl")
    assert_not_nil response
  end 

  def test_quote_declared_value_document_raw_xml    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(raw_xml: "testcases/test_quote_declared_value_document_raw.xml")    
    
    save_xml(response, "test_quote_declared_value_document_raw_xml")
    assert_not_nil response
  end
  
  def test_quote_declared_document
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(weight: 0.2)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      package_type: "document",
      origin_country_code: "MX",
      destination_country_code: "US", 
      origin_postal_code: "11510", 
      destination_postal_code: "90210",
      pieces: pieces,
      declared_currency: "USD",
      declared_value: 100       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_declared_document")
    assert_not_nil response
  end     
  
  
  def test_quote_insured_value_document_raw_xml    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(raw_xml: "testcases/test_quote_insured_value_document_raw.xml")    
    
    save_xml(response, "test_quote_insured_value_document_raw_xml")
    assert_not_nil response
  end      
  
  def test_quote_insured_document
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(weight: 0.2)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      package_type: "document",
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      pieces: pieces,
      insured_currency: "MXN",
      insured_value: 100       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_insured_document")
    assert_not_nil response
  end     
  
  
  def test_quote_insured_raw_xml 
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(raw_xml: "testcases/test_quote_insured_raw.xml")    
    
    save_xml(response, "test_quote_insured_raw_xml")
    assert_not_nil response
  end      
  
  def test_quote_insured
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      pieces: pieces,
      insured_currency: "MXN",
      insured_value: 100       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_insured_dhl")
    assert_not_nil response
  end     
  
end