# -*- encoding: utf-8 -*-
require 'nokogiri'

module ActiveMerchant
  module Shipping

    class UPS < Carrier
      include ActiveMerchant::Shipping::UpsConstants            
      
      self.retry_safe = true

      cattr_reader :name
      @@name = "UPS"
      
      TEST_URL = 'https://wwwcie.ups.com'
      LIVE_URL = 'https://onlinetools.ups.com'

      def find_quotes(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        else        
          request = options[:request]
          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]  
          
          xml = request.to_xml
        end
        response_raw = commit(UpsConstants::RESOURCES[:rates], save_request(xml), (options[:test] || false))             
        resp = parse_quote_response(Nokogiri::XML(response_raw))

        resp.response = response_raw
        resp.request = last_request
        resp
      end


      def parse_quote_response(document)
        response = UpsQuoteResponse.new
        response.success = parse_status(document)
        response.notes = parse_notes(document)
        response.quotes = parse_quotes(document)
        
        response
      end

      protected
      
        def parse_status(document)
          success = true
          status = document.xpath("//RatingServiceSelectionResponse/Response")
          
          status.each do |s|
            code = nil
            code = s.at('ResponseStatusCode').text if s.at('ResponseStatusCode')
            if code && code != "1"
              success = false
            end             
          end
          success        
        end
                
        def parse_quotes(document)
          back = []
          quotes = document.xpath("//RatedShipment")
          
          quotes.each do |q|
            quote = UpsQuote.new

            tag_value(quote, "Service/Code", q, "product_code")
            tag_value(quote, "TransportationCharges//CurrencyCode", q, "currency")
            tag_value(quote, "TransportationCharges//MonetaryValue", q, "base_charge")            
            tag_value(quote, "TotalCharges//MonetaryValue", q, "total_charge")                        
            tag_value(quote, "ServiceOptionsCharges//MonetaryValue", q, "surcharge")                                                
            
            back << quote
          end
          back       
        end         
        
        def parse_notes(document)
          back = []
          errors = document.xpath("//RatingServiceSelectionResponse/Response/Error")
          
          errors.each do |e|
            note = UpsNote.new
            note.severity = e.at('ErrorSeverity').text if e.at('ErrorSeverity')
            note.message = e.at('ErrorDescription').text if e.at('ErrorDescription')
            note.code = e.at('ErrorCode').text if e.at('ErrorCode')                    
            back << note
          end
          back
        end                   
        
        def commit(action, request, test = false)
          ssl_post("#{test ? TEST_URL : LIVE_URL}/#{action}", request)
        end
        
        def tag_value(object, xml_tag, document, attribute, float = false)
          tag = document.xpath("#{xml_tag}")          
          if tag
            v = tag.text
            v = v.to_f if float
            object.send("#{attribute}=", v)
          end
        end        
        
    end
  end
end