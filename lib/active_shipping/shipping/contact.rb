module ActiveMerchant
  module Shipping
    class Contact

      attr_reader :company_name, :title, :person_name, :department, :phone_number, :pager_number, :fax_number, :email_address
      attr_accessible :company_name, :title, :person_name, :department, :phone_number, :pager_number, :fax_number, :email_address      
      
      def initialize(options = {})
        @company_name = options[:company_name]
        @title = options[:title]
        @person_name = options[:person_name]
        @department = options[:department]
        @phone_number = options[:phone_number]                                
        @pager_number = options[:pager_number]                                
        @fax_number = options[:fax_number]                                
        @email_address = options[:email_address]                                                        
      end
      
      def fedex_xml
        xml = XmlNode.new('Contact') do |contact|                  
          contact << XmlNode.new('Title', title) if title
          contact << XmlNode.new('PersonName', person_name) if person_name          
          contact << XmlNode.new('CompanyName', company_name) if company_name
          contact << XmlNode.new('Department', department) if department
          contact << XmlNode.new('PhoneNumber', phone_number) if phone_number
          contact << XmlNode.new('PagerNumber', pager_number) if pager_number                              
          contact << XmlNode.new('FaxNumber', fax_number) if fax_number                              
          contact << XmlNode.new('EmailAddress', email_address) if email_address                                                  
        end
        xml
      end
      
    end
  end
end
