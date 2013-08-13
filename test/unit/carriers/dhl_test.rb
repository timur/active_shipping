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


end
