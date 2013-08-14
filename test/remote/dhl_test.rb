# encoding: utf-8
require_relative '../test_helper'

class DhlTest < Test::Unit::TestCase

  def setup
  end
      
  def test_quote
   # packages = [
   #   ShippingPackage.new(100, [93,10])
   # ]
   # 
   # address_shipper = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Ciudad de México', postal_code: '16034', country_code: 'MX')
   # address_rec = ActiveMerchant::Shipping::ShippingAddress.new(street_lines: 'Main Street', city: 'Laderas de Monterrey', postal_code: '22046', country_code: 'MX', residential: true)
   # 
   # contact_shipper = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Sender", company_name: "Company")
   # contact_recipient = ActiveMerchant::Shipping::ShippingContact.new(person_name: "Recipient", company_name: "Company") 
   # 
   # shipper = ActiveMerchant::Shipping::ShippingShipper.new(address: address_shipper, contact: contact_shipper)   
   # recipient = ActiveMerchant::Shipping::ShippingRecipient.new(address: address_rec, contact: contact_recipient)       
   # 
   # fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
   # response = fedex.find_quotes(shipper: shipper, recipient: recipient, packages: packages, envelope: false)
   # 
   # fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
   #   [rate.service_name, rate.price]
   # }
   # 
   # assert_not_nil fedex_rates
  end
end
