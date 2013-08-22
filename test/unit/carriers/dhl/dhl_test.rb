require 'test_helper'
require 'rexml/document'

class DhlTest < Test::Unit::TestCase
  
  def setup
  end
  
  def test_quote_xml
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    
    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(site_id: "10", password: "pass", pieces: pieces)
    assert_not_nil quote.to_xml
  end

  def test_shipping_xml
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      site_id: "10", 
      password: "pass", 
      shipper_account_number: "12345",
      consignee_company: "Company Consignee",
      consignee_address_line: "Con Address",      
      consignee_city: "Con City",
      consignee_postalcode: "12345",
      consignee_countrycode: "MX",
      shipment_details_number_of_pieces: 2,
      shipment_details_weight: 2,
      shipment_details_global_product_code: "P",
      shipment_details_local_product_code: "P",
      shipment_details_date: "2013-08-08",
      shipment_details_packageType: "CP",
      shipment_details_currencyCode: "MXN",
      dutiable: false,
      shipper_shipper_id: "ID",
      shipper_company: "company",
      shipper_address_line: "Shipper Address Line",
      shipper_countrycode: "MX",
      shipper_city: "shipper City",
      shipper_countryname: "Mexico",
      pieces: pieces
    )
    
    assert_not_nil shipment.to_xml
  end
  
  def test_number_of_pieces
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(quantity: 3, height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    pieces << ActiveMerchant::Shipping::DhlPiece.new(quantity: 1, height: 20, width: 20, depth: 20, weight: 2.5)            
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    assert shipment.shipment_details_number_of_pieces == 5
  end  

  def test_country_name
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      shipper_countrycode: 'MX',
      consignee_countrycode: 'DE'      
    )
    
    shipment.calculate_attributes
    
    assert shipment.shipper_countryname == 'Mexico'
    assert shipment.consignee_countryname == 'Germany'    
  end  

  def test_country_name
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      shipper_countrycode: 'MX'     
    )
    
    shipment.calculate_attributes
    
    assert shipment.shipment_details_currencyCode == 'MXN' 
  end  
  
  def test_calculate_weight
    pieces = []
    pieces << ActiveMerchant::Shipping::DhlPiece.new(quantity: 3, height: 10, width: 10, depth: 10, weight: 1.5)
    pieces << ActiveMerchant::Shipping::DhlPiece.new(height: 20, width: 20, depth: 20, weight: 2.5)        
    pieces << ActiveMerchant::Shipping::DhlPiece.new(quantity: 1, height: 20, width: 20, depth: 20, weight: 2.5)            
    
    shipment = ActiveMerchant::Shipping::DhlShipmentRequest.new(
      pieces: pieces
    )
    
    shipment.calculate_attributes
    
    assert shipment.shipment_details_weight == 9.5
  end  
  
  def test_quote_validation
    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new
    assert quote.valid? == false
    
    assert quote.errors[:destination_postal_code].any?
    assert quote.errors[:destination_country_code].any?    
    
    assert quote.errors[:origin_postal_code].any?
    assert quote.errors[:origin_country_code].any?        
    
    
    quote = ActiveMerchant::Shipping::DhlQuoteRequest.new(destination_postal_code: "12345", origin_country_code: "MX")
    assert quote.valid? == false
    
    assert !quote.errors[:destination_postal_code].any?
    assert quote.errors[:destination_country_code].any?    
    
    assert quote.errors[:origin_postal_code].any?
    assert !quote.errors[:origin_country_code].any?                
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

  def test_parse_quote_response_mexico
    f = File.open(MODEL_FIXTURES + "xml/dhl/response_mexico_quote.xml")
    doc = Nokogiri::XML(f)
    f.close
    dhl = Dhl.new(site_id: 'DHLMexico', password: 'hUv5E3nMjQz6', test: true)
    response = dhl.parse_quote_response(doc)
    
    assert response.class.to_s, ActiveMerchant::Shipping::DhlQuoteResponse.class.to_s     
    assert_equal response.notes.size, 0
    assert_operator response.quotes.size, :>, 0
    assert_equal response.quotes[0].base_charge, 39 
    assert_equal response.quotes[0].total_tax_amount, 8   
    assert_equal response.quotes[0].delivery_date_calculated.hour, 9       
    
    assert_equal response.quotes[1].extra_charges.size, 1    
    assert_equal response.quotes[1].extra_charges[0].global_service_name, "FUEL SURCHARGE"            
    assert_equal response.quotes[1].extra_charges[0].charge_value, 2.57

    assert_equal response.quotes[1].pickup_date, Date.parse('2013-08-15')
    assert_equal response.quotes[1].exchange_rate, 1.3612
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
