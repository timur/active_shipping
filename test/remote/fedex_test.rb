# encoding: utf-8
require_relative '../test_helper'

class FedExTest < Test::Unit::TestCase

  def setup
    @packages  = TestFixtures.packages
    @locations = TestFixtures.locations
    @carrier   = FedEx.new(fixtures(:fedex).merge(:test => true))
  end
    
  def test_rate
    packages = [
      ShippingPackage.new(  100,               
                    [93,10],           
                    :currency => "EUR")
    ]
    
    address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Harrison', state_or_providence_code: 'AR', postal_code: '72601', country_code: 'US')
    address_rec = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Richmond', state_or_providence_code: 'BC', postal_code: 'V7C4V4', country_code: 'CA', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_rates(shipper, recipient, packages)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
    assert_not_nil fedex_rates   
  end
  
  def test_rate_mexico
    packages = [
      ShippingPackage.new(100, [93,10])
    ]
    
    address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Ciudad de México', postal_code: '16034', country_code: 'MX')
    address_rec = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Laderas de Monterrey', postal_code: '22046', country_code: 'MX', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company")
    contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company") 
    
    shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_rates(shipper, recipient, packages)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
    puts fedex_rates
    assert_not_nil fedex_rates
  end


  def test_rate_germany
    packages = [
      ShippingPackage.new(2000, [10, 10, 10], :units => :metric)
    ]
    
    address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Oberursel', postal_code: '61440', country_code: 'DE')
    address_rec = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Frankfurt', postal_code: '60385', country_code: 'DE', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_rates(shipper, recipient, packages)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      puts rate.currency
      puts rate.delivery_date      
      [rate.service_name, rate.price]
    }
    
    puts fedex_rates.to_s        
  end
  
  def test_ship
    packages = [
      ShippingPackage.new(  100,               
                    [93,10],           
                    :currency => "EUR")
    ]
    
    address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Harrison', state_or_providence_code: 'AR', postal_code: '72601', country_code: 'US')
    address_rec = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Franklin Park', state_or_providence_code: 'IL', postal_code: '60131', country_code: 'US', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    shipping_response = fedex.ship(shipper, recipient, packages, '510087267')
    assert_not_nil shipping_response.tracking_number    
  end    

  #def test_tracking
  #  assert_nothing_raised do
  #    @carrier.find_tracking_info('077973360403984', :test => true)
  #  end
  #end
  #
  #def test_tracking_with_bad_number
  #  assert_raises ResponseError do
  #    response = @carrier.find_tracking_info('12345')
  #  end
  #end
  #
  #def test_different_rates_for_commercial
  #  residential_response = @carrier.find_rates(
  #                           @locations[:beverly_hills],
  #                           @locations[:ottawa],
  #                           @packages.values_at(:chocolate_stuff)
  #                         )
  #  commercial_response  = @carrier.find_rates(
  #                           @locations[:beverly_hills],
  #                           Location.from(@locations[:ottawa].to_hash, :address_type => :commercial),
  #                           @packages.values_at(:chocolate_stuff)
  #                         )
  #
  #  assert_not_equal residential_response.rates.map(&:price), commercial_response.rates.map(&:price)
  #end
end
