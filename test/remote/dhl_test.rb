# encoding: utf-8
require_relative '../test_helper'

class DhlTest < Test::Unit::TestCase

  def setup
  end
      
  def test_quote
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "DE",
      destination_country_code: "DE", 
      origin_postal_code: "60385", 
      destination_postal_code: "61440",
      pieces: pieces       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(dhl, "test_quote")
    assert_not_nil response
  end
  
  def test_quote_mexico
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "MX", 
      origin_postal_code: "11510", 
      destination_postal_code: "11510",
      pieces: pieces       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(dhl, "test_quote_mexico")
    assert_not_nil response
  end  

  def test_quote_mexico_germany
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "MX",
      destination_country_code: "DE", 
      origin_postal_code: "11510", 
      destination_postal_code: "61440",
      pieces: pieces       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(dhl, "test_quote_mexico_germany")
    assert_not_nil response
  end  
  
  def test_quote_declared
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)

    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(
      origin_country_code: "DE",
      destination_country_code: "DE", 
      origin_postal_code: "60385", 
      destination_postal_code: "61440",
      pieces: pieces,
      declared_currency: "EUR",
      declared_value: 100       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(dhl, "test_quote_declared")
    assert_not_nil response
  end  
  
  def test_parse_quote_response
    f = File.open(MODEL_FIXTURES + "xml/dhl/response_note.xml")
    doc = Nokogiri::XML(f)
    f.close
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_quote_response(doc)
    
    assert response.class.to_s, ActiveMerchant::Shipping::DhlQuoteResponse.class.to_s     
    assert_equal response.notes.size, 1
    assert_equal response.notes[0].data, "Product not available between this origin and destination."
  end
  
  def test_parse_quote_response_corroup
    f = File.open(MODEL_FIXTURES + "xml/dhl/response_note_corrupt.xml")
    doc = Nokogiri::XML(f)
    f.close
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_quote_response(doc)
    
    assert response.class.to_s, ActiveMerchant::Shipping::DhlQuoteResponse.class.to_s     
  end  
end