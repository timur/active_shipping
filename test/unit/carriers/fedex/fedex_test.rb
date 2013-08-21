require 'test_helper'

class FedExTest < Test::Unit::TestCase
  def setup
  end
  
  def test_quote_xml
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 3, height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::FedexPackage.new(height: 20, width: 20, length: 20, weight: 2.5)        
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 20, width: 20, length: 20, weight: 2.5)            
    
    request = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      packages: packages
    )

    assert_not_nil request.to_xml
  end  
  
  def test_calculate_pieces
    packages = []
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 3, height: 10, width: 10, length: 10, weight: 1.5)
    packages << ActiveMerchant::Shipping::FedexPackage.new(height: 20, width: 20, length: 20, weight: 2.5)        
    packages << ActiveMerchant::Shipping::FedexPackage.new(quantity: 1, height: 20, width: 20, length: 20, weight: 2.5)            
    
    request = ActiveMerchant::Shipping::FedexQuoteRequest.new(
      packages: packages
    )
    
    request.calculate_attributes
    
    assert request.package_count == 5
  end
end
