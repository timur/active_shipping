require 'erb'
require 'virtus'

module ActiveMerchant
  module Shipping
        
    class UpsShipmentRequest
      include Virtus.model
      
      include ActiveModel::Validations    
      include ActiveMerchant::Shipping::UpsConstants
      include ActiveMerchant::Shipping::Constants              
      
      # authorization
      attribute :access_license_number, String
      attribute :user_id, String      
      attribute :password, String      
      
      attribute :account_number, String
      attribute :product_code, String                  
      
      attribute :package_type, String, default: UpsConstants::PACKAGE

      attribute :reference, String
      attribute :description, String      
      
      # Pickup 
      attribute :pickup_type, String
      
      attribute :shipper_number, String
      attribute :shipper_name, String
      attribute :shipper_attention, String            
      attribute :shipper_phone, String
      attribute :shipper_address, String      
      attribute :shipper_city, String
      attribute :shipper_postal_code, String      
      attribute :shipper_country, String
      
      attribute :ship_to_company, String
      attribute :ship_to_name, String
      attribute :ship_to_phone, String
      attribute :ship_to_address, String
      attribute :ship_to_city, String
      attribute :ship_to_state_code, String                  
      attribute :ship_to_postal_code, String
      attribute :ship_to_country, String
      
      attribute :ship_from_company, String
      attribute :ship_from_name, String
      attribute :ship_from_phone, String
      attribute :ship_from_address, String
      attribute :ship_from_state_code, String            
      attribute :ship_from_city, String
      attribute :ship_from_postal_code, String
      attribute :ship_from_country, String              
      
      attribute :document_weight, Float
      attribute :envelope, Boolean, default: false            

      attribute :customer_classification, String, default: UpsConstants::CLASSIFICATION_DAILY_RATES
      
      attribute :declared_value, String      
      attribute :declared_currency, String            

      attribute :insured_value, String      
      attribute :insured_currency, String            

      attribute :packages, Array    
      
      def to_xml
        ERB.new(File.new(xml_template_path).read, nil,'%<>-').result(binding)
      end      
      
      def dutiable?
        declared_currency && declared_value
      end
      
      def insured?
        insured_currency && insured_value
      end
      
      def insure_for_package
        i = 1
        if @packages.size > 0
          i = @packages.size
        end
        
        @insured_value.to_f / i
      end      
      
      def calculate_company
        if @ship_to_company.blank?
          return "#{@ship_to_name}"
        else
          return @ship_to_company
        end
      end
      
      def calculate_weight
        return @document_weight if @envelope
        weight = 0
        if packages && packages.size > 0
          packages.each do |package|
            puts "PACKAGE #{package.class}"
            weight += package.weight
          end
        end
        weight
      end      
            
      private
        def xml_template_path
          spec = Gem::Specification.find_by_name("active_shipping")
          gem_root = spec.gem_dir
          gem_root + "/lib/active_shipping/shipping/carriers/ups/templates/ship_confirm.xml.erb"
        end
    end
  end
end