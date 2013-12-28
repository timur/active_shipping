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
      
      attr_reader :key, :password, :accountNumber, :meterNumber          

      #TEST_URL = 'https://gatewaybeta.fedex.com:443/xml'cd      
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

        response_raw = commit(save_request(xml), true)             

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
        resp.response = response_raw
        resp.request = last_request
        
        resp        
      end
      
      def tracking(options = {})
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

        response_raw = commit(save_request(xml), true)             

        resp = parse_tracking_response(Nokogiri::XML(response_raw))
        resp.response = response_raw
        resp.request = last_request
        resp
      end      
      
      def self.service_name_for_code(service_code)
        ServiceTypes[service_code] || "FedEx #{service_code.titleize.sub(/Fedex /, '')}"
      end      

      def commit(request, test = true)
        res = nil
        begin
          res = ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))                        
        rescue Exception => e
        end
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
      
      def parse_tracking_response(document)
        document.remove_namespaces!
        response = FedexTrackingResponse.new
        parse_notes(response, document)
        response_success(response, document, "//TrackReply/HighestSeverity")
        parse_tracking(response, document)

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
      
      def parse_tracking(response, document)
        track_details = document.xpath("//TrackDetails")   
        response.tracking_number_unique_identifier = track_details.at('TrackingNumberUniqueIdentifier').text if track_details.at('TrackingNumberUniqueIdentifier')
        response.ship_timestamp = track_details.at('ShipTimestamp').text if track_details.at('ShipTimestamp')

        events = document.xpath("//Events")        
        
        events.each do |event|
          e = FedexTrackingEvent.new
          tag_value(e, "Timestamp", event, "timestamp")
          tag_value(e, "EventType", event, "event_type")
          tag_value(e, "EventDescription", event, "event_description")          
          tag_value(e, "ArrivalLocation", event, "arrival_location")                    
          tag_value(e, "Address//City", event, "city")          
          tag_value(e, "Address//PostalCode", event, "postal_code")          
          tag_value(e, "Address//CountryCode", event, "country_code")          
          tag_value(e, "Address//Residential", event, "residential")          
                    
          response.tracking_events << e
        end        
      end      
      
      def parse_quotes(response, document)
        rate_reply_details = document.xpath("//RateReplyDetails")   

        rate_reply_details.each do |details|
          q = FedexQuote.new
          q.product_code = details.at('ServiceType').text if details.at('ServiceType')
          q.product_name = ServiceTypes[q.product_code]
          q.delivery_time = details.at('CommitTimestamp').text if details.at('CommitTimestamp')          
          if q && q.delivery_time
            q.delivery_date = Time.parse(q.delivery_time)
          end
          
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
                                                        
          surcharges = current_detail.xpath("ShipmentRateDetail/Surcharges")
          surcharges.each do |surcharge|
            s = FedexSurcharge.new
            s.surcharge_type = surcharge.at('SurchargeType').text                                        
            s.description = surcharge.at('Description').text                                                    
            s.amount = surcharge.at('Amount/Amount').text                                                    
            quote.extra_charges << s
          end
          
          taxes = current_detail.xpath("ShipmentRateDetail/Taxes")
          taxes.each do |tax|
            tax_type = tax.xpath('TaxType')
            if tax_type && tax_type.text == "VAT"
              amount = taxes.xpath('Amount')
              if amount
                quote.taxes = amount.at('Amount/Amount').text          
                c = amount.at('Amount/Currency').text                                          
                if quote.total_charge && quote.taxes
                  share = quote.taxes.to_f * 100 / quote.total_charge
                  quote.tax_rate = share
                end
              end
            end
          end          
        end                
      end            
      
      def response_success(response, document, xpath = "//HighestSeverity")        
        highest = document.xpath(xpath)
        highest_text = highest.text
        highest_text.strip!        
                
        a = %w{SUCCESS WARNING NOTE success warning note}        
        
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
