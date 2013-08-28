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
      pieces: pieces       
    )

    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.find_quotes(request: quote)    
    
    save_xml(response, "test_quote_mexico")
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

  def test_shipment_static    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(raw_xml: "request_shipment_dhl.xml")    
    
    save_xml(response, "test_shipment_static")
    assert_not_nil response
  end  
  
  def test_shipment_mexico
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S",        
      shipper_account_number: "980526857",
      billing_account_number: "980526857",      
      consignee_company: "Company Consignee",
      consignee_address_line: "Con Address",  
      consignee_city: "Con City",
      consignee_postalcode: "11510",
      consignee_countrycode: "MX",
      consignee_countryname: "Mexico",            
      contact_consignee_fullname: "Hans Meier",
	  	contact_consignee_phonenumber: "12345",
	  	contact_consignee_phoneext: "99",	  		  	
      shipment_details_number_of_pieces: 2,
      shipment_details_weight: 2,
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: "2013-08-25",
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: false,
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
	  	contact_shipper_phoneext: "99",	  		  	
      pieces: pieces
    )
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_mexico")
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
    
    save_xml(response, "test_quote_declared")
    assert_not_nil response
  end  
   
end