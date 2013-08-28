require 'nokogiri'
require 'time'

module ActiveMerchant
  module Shipping
    
    # :key is your developer API key
    # :password is your API password
    # :account is your FedEx account number
    # :login is your meter number
    class FedEx < Carrier      
      include ActiveMerchant::Shipping::FedexConstants   
      include ActiveMerchant::Shipping::Constants                 

      #TEST_URL = 'https://gatewaybeta.fedex.com:443/xml'
      
      TEST_URL = 'https://wsbeta.fedex.com:443/web-services'            
      LIVE_URL = 'https://gateway.fedex.com:443/xml'
            
      def requirements
        [:key, :password, :accountNumber, :meterNumber]
      end
      
      def find_quotes(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/fedex/#{options[:raw_xml]}").read
        else
          request = options[:request]

          request.key = @options[:key]
          request.password = @options[:password]        
          request.accountNumber = @options[:accountNumber]        
          request.meterNumber = @options[:meterNumber]                        
          
          xml = request.to_xml
        end        

        response_raw = commit(save_request(xml), (@options[:test] || false))             

        resp = parse_quote_response(Nokogiri::XML(response_raw))
        resp.response = response_raw
        resp.request = last_request
        resp
      end
      
      def shipment(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/fedex/#{options[:raw_xml]}").read
        else
          request = options[:request]

          request.key = @options[:key]
          request.password = @options[:password]        
          request.accountNumber = @options[:accountNumber]        
          request.meterNumber = @options[:meterNumber]                        
          
          xml = request.to_xml
        end        

        response_raw = commit(save_request(xml), (@options[:test] || false))             

        resp = parse_shipment_response(Nokogiri::XML(response_raw))
        resp = FedexShipmentResponse.new
        resp.response = response_raw
        resp.request = last_request
        resp        
      end
      
      def self.service_name_for_code(service_code)
        ServiceTypes[service_code] || "FedEx #{service_code.titleize.sub(/Fedex /, '')}"
      end      

      def commit(request, test = true)
        res = ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))              
        res
      end
      
      def parse_quote_response(document)
        document.remove_namespaces!
        response = FedexQuoteResponse.new
        parse_notes(response, document)
        response_success(response, document)
        parse_quotes(response, document)
        
        response
      end      

      def parse_shipment_response(document)
        document.remove_namespaces!
        response = FedexShipmentResponse.new
        parse_notes(response, document)
        response_success(response, document)
        parse_shipment(response, document)

        response
      end      

      protected
      
      def parse_notes(response, document)
        notes = document.xpath("//Notifications")
        
        notes.each do |note|
          n = FedexNote.new
          n.severity = note.at('Severity').text if note.at('Severity')
          n.source = note.at('Source').text if note.at('Source')
          n.code = note.at('Code').text if note.at('Code')
          n.message = note.at('LocalizedMessage').text if note.at('LocalizedMessage')

          response.notes << n
        end        
      end

      def parse_shipment(response, document)
        tracking_ids = document.xpath("//TrackingIds")   
        response.trackingnumber = tracking_ids.at('TrackingNumber').text if tracking_ids.at('TrackingNumber')
        
        parts = document.xpath("//Label//Parts")   
        response.label = parts.at('Image') if parts.at('Image')
      end
      
      def parse_quotes(response, document)
        rate_reply_details = document.xpath("//RateReplyDetails")   

        rate_reply_details.each do |details|
          q = FedexQuote.new
          q.product_code = details.at('ServiceType').text if details.at('ServiceType')
          q.product_name = ServiceTypes[q.product_code]
          q.delivery_time = details.at('CommitTimestamp').text if details.at('CommitTimestamp')          
          q.delivery_date = Time.parse(q.delivery_time)
          
          parse_rated_shipment_details(q, details.xpath("RatedShipmentDetails"))
          response.quotes << q
        end        
      end
      
      def parse_rated_shipment_details(quote, details)
        current_detail = nil
        details.each do |detail|
          curr = detail.xpath("ShipmentRateDetail//CurrencyExchangeRate")
          if curr
            from = curr.at('FromCurrency').text
            into = curr.at('IntoCurrency').text              
            
            if from == into
              current_detail = detail
            end
          end
        end
        
        if current_detail
          quote.currency = current_detail.at('TotalBaseCharge//Currency').text
          quote.currency = "MXN" if quote.currency == "NMP"
          quote.base_charge = current_detail.at('TotalBaseCharge//Amount').text          
          quote.total_charge = current_detail.at('TotalNetCharge//Amount').text                    
          quote.surcharge = current_detail.at('TotalSurcharges//Amount').text                              
          quote.taxes = current_detail.at('TotalTaxes//Amount').text    
                                                        
          surcharges = current_detail.xpath("ShipmentRateDetail/Surcharges")
          surcharges.each do |surcharge|
            s = FedexSurcharge.new
            s.surcharge_type = surcharge.at('SurchargeType').text                                        
            s.description = surcharge.at('Description').text                                                    
            s.amount = surcharge.at('Amount/Amount').text                                                    
            quote.extra_charges << s
          end
        end                
      end            
      
      def response_success(response, document)
        highest = document.xpath("//HighestSeverity")
        highest_text = highest.text
                
        a = %w{SUCCESS WARNING NOTE}
        if a.include? highest_text
          response.success = true
        else
          response.success = false
        end
      end

      def tag_value(object, xml_tag, document, attribute)
        tag = document.xpath("#{xml_tag}")   
        object.send("#{attribute}=", tag.text) if tag          
      end
    end
  end
end
