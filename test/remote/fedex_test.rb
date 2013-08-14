# encoding: utf-8
require_relative '../test_helper'

class FedExTest < Test::Unit::TestCase

  def setup
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
    response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
    assert_not_nil fedex_rates   
  end
  
  def test_rate_insured
    packages = [
      ShippingPackage.new(100, [93,10])
    ]
    
    address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(
      postal_code: '80915', country_code: 'US'
    )
    
    address_rec = ActiveMerchant::Shipping::ShippingAddress.new(
      postal_code: 'V7C4V4', country_code: 'CA', residential: true
    )
    
    contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company")
    contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company") 
    
    shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false, insured_value: 100, insured_currency: "NMP")

    save_xml(fedex, "test_rate_insured")
    
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
    response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false)

    save_xml(fedex, "test_rate_mexico")
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
    assert_not_nil fedex_rates
  end
  
  def test_rate_mexico_eur
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
    response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false, preferred_currency: "EUR")

    save_xml(fedex, "test_rate_mexico_eur")
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
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
    response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false)

    save_xml(fedex, "test_rate_germany")
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
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
    shipping_response = fedex.ship(shipper, recipient, packages, account_number: '510087267', service_code: 'GROUND_HOME_DELIVERY')
    assert_not_nil shipping_response.tracking_number    
  end    
  
  def test_xml_request
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)    
    request = File.open(Dir.pwd + '/test/fixtures/xml/fedex/request2.xml').read
    res = fedex.commit(request)            
  end
  
  #def test_ship_response
  #  resp = xml_fixture("fedex/response_ship")
  #  fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
  #  response = fedex.send(:parse_ship_response, nil, resp)
  #  
  #  assert_not_empty response.tracking_number
  #  assert_equal response.tracking_number, '794807741785'
  #end
  
  def test_track
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    xml = fedex.send(:build_tracking_request, 794807744935)
  end
end