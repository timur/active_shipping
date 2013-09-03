# encoding: utf-8
require_relative '../test_helper'

class DhlTest < Test::Unit::TestCase

  def setup
  end      
  

  def test_shipment_static    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(raw_xml: "request_shipment_dhl.xml")    
    
    save_xml(response, "test_shipment_static_dhl")
    assert_not_nil response
  end  

  def test_shipment_play    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(raw_xml: "ship_dhl_play.xml")    
    
    save_xml(response, "test_shipment_play_dhl")
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
      shipment_details_date: Date.today,
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
    
    save_xml(response, "test_shipment_mexico_dhl")
    assert_not_nil response
  end 
  
  def test_shipment_declared
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      declared_value: 200,
      declared_currency: "MXN",       
      shipper_account_number: "980526857",
      billing_account_number: "980526857",      
      consignee_company: "Company Consignee",
      consignee_address_line: "Con Address",  
      consignee_city: "Con City",
      consignee_postalcode: "90210",
      consignee_countrycode: "US",
      consignee_countryname: "Mexico",            
      contact_consignee_fullname: "Hans Meier",
	  	contact_consignee_phonenumber: "12345",
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: true,
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_declared_dhl")
    assert_not_nil response
  end    

  def test_shipment_reference
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
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
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: false,
      shipment_reference: "REF BY ME",
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_reference_dhl")
    assert_not_nil response
  end

  def test_shipment_reference_piece
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5, piece_content: "REF PIECE 123")
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
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
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: false,
      package_type: DhlConstants::PACKAGE,
      shipment_reference: "REF BY ME",
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_reference_piece_dhl")
    assert_not_nil response
  end

  def test_shipment_insured
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
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
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
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
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_insured_dhl")
    assert_not_nil response
  end    

  def test_shipment_multiple_packages
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.2)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 15, width: 20, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 19, width: 23, depth: 40, weight: 0.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 13, width: 21, depth: 33, weight: 2.0)            
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
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
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
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
	  	package_type: DhlConstants::PACKAGE ,
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_multiple_packages_dhl")
    assert_not_nil response
  end
  
  def test_shipment_declared_document
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(weight: 0.2)
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
      shipper_account_number: "980526857",
      billing_account_number: "980526857",      
      consignee_company: "Company Consignee",
      consignee_address_line: "Con Address",  
      consignee_city: "Con City",
      consignee_postalcode: "90210",
      consignee_countrycode: "US",
      consignee_countryname: "Mexico",            
      contact_consignee_fullname: "Hans Meier",
	  	contact_consignee_phonenumber: "12345",
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: true,
      declared_currency: "MXN",
      declared_value: 200,
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
	  	package_type: DhlConstants::DOCUMENT,
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_declared_document_dhl")
    assert_not_nil response
  end
  
  def test_shipment_insured_document
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(weight: 0.2)
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      language_code: "en",
      pieces_enabled: "Y",  
      shipper_payment_type: "S",
      duty_payment_type: "S", 
      shipment_details_insured_amount: 200,
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
      shipment_details_global_product_code: "K",
      shipment_details_local_product_code: "1",
      shipment_details_date: Date.today,
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      shipment_details_content: "FOR TESTING",
      dutiable: false,
      insured_value: 200,
      shipper_shipper_id: "654031018",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_countryname: "Mexico",
      shipper_postalcode: "11510",
      shipper_city: "shipper City",      
      contact_shipper_fullname: "Hans Meier",
	  	contact_shipper_phonenumber: "12345",
	  	package_type: DhlConstants::DOCUMENT,
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.shipment(request: shipment)    
    
    save_xml(response, "test_shipment_insured_document_dhl")
    assert_not_nil response
  end         
end