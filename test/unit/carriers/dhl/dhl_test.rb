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
end
