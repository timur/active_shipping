# encoding: utf-8
require_relative '../test_helper'

require_relative '../../lib/active_shipping/shipping/address'
require_relative '../../lib/active_shipping/shipping/contact'
require_relative '../../lib/active_shipping/shipping/shipper'
require_relative '../../lib/active_shipping/shipping/recipient'

class FedExTest < Test::Unit::TestCase

  def setup
    @packages  = TestFixtures.packages
    @locations = TestFixtures.locations
    @carrier   = FedEx.new(fixtures(:fedex).merge(:test => true))
  end
    
  def test_valid_credentials
    assert @carrier.valid_credentials?
  end
  
  def test_rate
    packages = [
      Package.new(  100,               
                    [93,10],           
                    :currency => "EUR")
    ]
    
    address_shipper = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Harrison', state_or_providence_code: 'AR', postal_code: '72601', country_code: 'US')
    address_rec = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Richmond', state_or_providence_code: 'BC', postal_code: 'V7C4V4', country_code: 'CA', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::Contact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::Contact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::Shipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::Recipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_rates(shipper, recipient, packages)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      [rate.service_name, rate.price]
    }
    
    puts fedex_rates.to_s        
  end
  
  def test_rate_mexico
    packages = [
      Package.new(100, [93,10])
    ]
    
    address_shipper = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Ciudad de México', postal_code: '16034', country_code: 'MX')
    address_rec = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Laderas de Monterrey', postal_code: '22046', country_code: 'MX', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::Contact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::Contact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::Shipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::Recipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    response = fedex.find_rates(shipper, recipient, packages)
    
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| 
      puts rate.currency
      puts rate.delivery_date      
      [rate.service_name, rate.price]
    }
    
    puts fedex_rates.to_s        
  end


  def test_rate_germany
    packages = [
      Package.new(2000, [10, 10, 10], :units => :metric)
    ]
    
    address_shipper = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Oberursel', postal_code: '61440', country_code: 'DE')
    address_rec = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Frankfurt', postal_code: '60385', country_code: 'DE', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::Contact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::Contact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::Shipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::Recipient.new(address: address_rec, contact: contact_recipient)       
    
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
      Package.new(  100,               
                    [93,10],           
                    :currency => "EUR")
    ]
    
    address_shipper = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Harrison', state_or_providence_code: 'AR', postal_code: '72601', country_code: 'US')
      address_rec = ActiveMerchant::Shipping::Address.new(street_lines: 'Main Street', city: 'Franklin Park', state_or_providence_code: 'IL', postal_code: '60131', country_code: 'US', residential: true)
    
    contact_shipper = ActiveMerchant::Shipping::Contact.new(person_name: "Sender", company_name: "Company", phone_number: "555-555-888")
    contact_recipient = ActiveMerchant::Shipping::Contact.new(person_name: "Recipient", company_name: "Company", phone_number: "555-555-888") 
    
    shipper = ActiveMerchant::Shipping::Shipper.new(address: address_shipper, contact: contact_shipper)   
    recipient = ActiveMerchant::Shipping::Recipient.new(address: address_rec, contact: contact_recipient)       
    
    fedex = FedEx.new(key: 'rscqm75MLampLUuV', password: '8rTZHQ6vbyOsGOgtwMXrZ1kIU', account: '510087267', login: '118511895', test: true)
    fedex.ship(shipper, recipient, packages, '510087267')    
  end    
    
  def test_us_to_canada
    response = nil
    assert_nothing_raised do
      response = @carrier.find_rates(
                   @locations[:beverly_hills],
                   @locations[:ottawa],
                   @packages.values_at(:wii)
                 )
      assert !response.rates.blank?
      response.rates.each do |rate|
        assert_instance_of String, rate.service_name
        assert_instance_of Fixnum, rate.price
      end
    end
  end
  
  def test_zip_to_zip_fails
    begin
      @carrier.find_rates(
        Location.new(:zip => 40524),
        Location.new(:zip => 40515),
        @packages[:wii]
      )
    rescue ResponseError => e
      assert_match /country\s?code/i, e.message
      assert_match /(missing|invalid)/, e.message
    end
  end
  
  # FedEx requires a valid origin and destination postal code
  def test_rates_for_locations_with_only_zip_and_country  
    response = @carrier.find_rates(
                 @locations[:bare_beverly_hills],
                 @locations[:bare_ottawa],
                 @packages.values_at(:wii)
               )

    assert response.rates.size > 0
  end
  
  def test_rates_for_location_with_only_country_code
    begin
      response = @carrier.find_rates(
                   @locations[:bare_beverly_hills],
                   Location.new(:country => 'CA'),
                   @packages.values_at(:wii)
                 )
    rescue ResponseError => e
      assert_match /postal code/i, e.message
      assert_match /(missing|invalid)/i, e.message
    end
  end
  
  def test_invalid_recipient_country
    begin
      response = @carrier.find_rates(
                   @locations[:bare_beverly_hills],
                   Location.new(:country => 'JP', :zip => '108-8361'),
                   @packages.values_at(:wii)
                 )
    rescue ResponseError => e
      assert_match /postal code/i, e.message
      assert_match /(missing|invalid)/i, e.message
    end
  end
  
  def test_ottawa_to_beverly_hills
    response = nil
    assert_nothing_raised do
      response = @carrier.find_rates(
                   @locations[:ottawa],
                   @locations[:beverly_hills],
                   @packages.values_at(:book, :wii)
                 )
      assert !response.rates.blank?
      response.rates.each do |rate|
        assert_instance_of String, rate.service_name
        assert_instance_of Fixnum, rate.price
      end
    end
  end
  
  def test_ottawa_to_london
    response = nil
    assert_nothing_raised do
      response = @carrier.find_rates(
                   @locations[:ottawa],
                   @locations[:london],
                   @packages.values_at(:book, :wii)
                 )
      assert !response.rates.blank?
      response.rates.each do |rate|
        assert_instance_of String, rate.service_name
        assert_instance_of Fixnum, rate.price
      end
    end
  end
  
  def test_beverly_hills_to_london
    response = nil
    assert_nothing_raised do
      response = @carrier.find_rates(
                   @locations[:beverly_hills],
                   @locations[:london],
                   @packages.values_at(:book, :wii)
                 )
      assert !response.rates.blank?
      response.rates.each do |rate|
        assert_instance_of String, rate.service_name
        assert_instance_of Fixnum, rate.price
      end
    end
  end

  def test_tracking
    assert_nothing_raised do
      @carrier.find_tracking_info('077973360403984', :test => true)
    end
  end

  def test_tracking_with_bad_number
    assert_raises ResponseError do
      response = @carrier.find_tracking_info('12345')
    end
  end

  def test_different_rates_for_commercial
    residential_response = @carrier.find_rates(
                             @locations[:beverly_hills],
                             @locations[:ottawa],
                             @packages.values_at(:chocolate_stuff)
                           )
    commercial_response  = @carrier.find_rates(
                             @locations[:beverly_hills],
                             Location.from(@locations[:ottawa].to_hash, :address_type => :commercial),
                             @packages.values_at(:chocolate_stuff)
                           )

    assert_not_equal residential_response.rates.map(&:price), commercial_response.rates.map(&:price)
  end
end
