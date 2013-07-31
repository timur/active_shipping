module ActiveMerchant
  module Shipping
    class Address

      attr_reader :street_lines, :city, :state_or_providence_code, :postal_code, :country_code, :urbanization_code, :residential
      attr_accessible :street_lines, :city, :state_or_providence_code, :postal_code, :country_code, :urbanization_code, :residential            

      def initialize(options = {})
        @street_lines = options[:street_lines]
        @city = options[:city]
        @state_or_providence_code = options[:state_or_providence_code]
        @postal_code = options[:postal_code]
        @country_code = options[:country_code]                                
        @urbanization_code = options[:urbanization_code]                                
        @residential = options[:residential]                                        
      end
      
      def fedex_xml
        xml = XmlNode.new('Address') do |address|                  
          address << XmlNode.new('StreetLines', street_lines) if street_lines
          address << XmlNode.new('City', city) if city          
          address << XmlNode.new('StateOrProvinceCode', state_or_providence_code) if state_or_providence_code          
          address << XmlNode.new('PostalCode', postal_code) if postal_code
          address << XmlNode.new('CountryCode', country_code) if country_code
          address << XmlNode.new('UrbanizationCode', urbanization_code) if urbanization_code                              
          address << XmlNode.new('Residential', residential) if residential                                        
        end
        xml
      end
      
    end
  end
end