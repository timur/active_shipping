# -*- encoding: utf-8 -*-
require 'nokogiri'

module ActiveMerchant
  module Shipping

    class UPS < Carrier
      include ActiveMerchant::Shipping::UpsConstants            
      
      self.retry_safe = true

      cattr_reader :name
      @@name = "UPS"
      
      attr_reader :user_id, :password, :access_license_number           
      attr_accessor :url           
      
      TEST_URL = 'https://wwwcie.ups.com'
      #https://wwwcie.ups.com/ups.app/xml/Track
      LIVE_URL = 'https://onlinetools.ups.com'

      def find_quotes(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        elsif options[:raw_string]
          xml = options[:raw_string]          
        else        
          request = options[:request]
          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]  
          
          xml = request.to_xml
        end
        response_raw = commit(UpsConstants::RESOURCES[:rates], save_request(xml), options[:test])             
        resp = parse_quote_response(Nokogiri::XML(response_raw))

        resp.response = response_raw
        resp.request = last_request
        resp
      end
      
      def tracking(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        elsif options[:raw_string]
          xml = options[:raw_string]                    
        else        
          request = options[:request]
          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]  
          
          xml = request.to_xml
        end
        response_raw = commit(UpsConstants::RESOURCES[:track], save_request(xml), true)             
        resp = parse_tracking_response(Nokogiri::XML(response_raw))
        
        resp.response = response_raw
        resp.request = last_request
        resp
      end
      
      def transit(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        elsif options[:raw_string]
          xml = options[:raw_string]                    
        else        
          request = options[:request]
          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]  
          
          xml = request.to_xml
        end
        response_raw = commit(UpsConstants::RESOURCES[:transit], save_request(xml), true)             
        resp = parse_transit_response(Nokogiri::XML(response_raw))
        
        resp.response = response_raw
        resp.request = last_request
        resp
      end            

      def ship_confirm(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        elsif options[:raw_string]
          xml = options[:raw_string]                    
        else        
          request = options[:request]
          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]            
          
          xml = request.to_xml
        end
        response_raw = commit(UpsConstants::RESOURCES[:ship_confirm], save_request(xml), true)             
        resp = parse_shipment_confirm_response(Nokogiri::XML(response_raw))
        
        resp.response = response_raw
        resp.request = last_request
        resp
      end

      def ship_accept(options = {})
        #puts "CALL SHIP ACCEPT #{ap options.keys}"
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/ups/#{options[:raw_xml]}").read
        elsif options[:raw_string]
          xml = options[:raw_string]                    
        else        
          request = options[:request]          
          request.access_license_number = @options[:access_license_number]
          request.user_id = @options[:user_id]
          request.password = @options[:password]            

          xml = request.to_xml
          #puts "SHIP ACCEPT HERE #{xml}"  
        end
                
        shipment = options[:shipment]
        
        response_raw = commit(UpsConstants::RESOURCES[:ship_accept], save_request(xml), true)             
        shipment = parse_accept_response(Nokogiri::XML(response_raw), shipment)
        
        [shipment, response_raw, last_request]
      end
      
      def shipment(options = {})
        #puts "CALL SHIPMENT in active shipping #{ap options} #{caller}"
        response_confirm = self.ship_confirm(options)
        
        r = ActiveMerchant::Shipping::UpsShipmentConfirmRequest.new(
          digest: response_confirm.digest
        )

        results = self.ship_accept(request: r, shipment: response_confirm.shipment)         
        s = results[0]
        
        response_confirm.shipment = s
        response_confirm.request_confirm = response_confirm.request
        response_confirm.response_confirm = response_confirm.response        

        response_confirm.request = results[2]
        response_confirm.response = results[1] 
        
        response_confirm.success = s.success
        response_confirm.errors = s.message       
        response_confirm
      end

      def parse_quote_response(document)
        response = UpsQuoteResponse.new
        response.success = parse_status(document)
        response.notes = parse_notes(document)
        response.quotes = parse_quotes(document)
        
        response
      end

      def parse_transit_response(document)
        response = UpsTransitResponse.new
        response.success = parse_transit_status(document)
        response = parse_transit(response, document)
        
        response
      end      
      
      def parse_shipment_confirm_response(document)
        response = UpsShipmentResponse.new
        response.success = parse_confirm_status(document)
        response.errors = parse_notes(document)        
        response.shipment = parse_shipment(document)
        
        response.digest = document.xpath("//ShipmentDigest")
        
        response
      end      

      def parse_shipment(document)
        shipment = UpsShipment.new                
        
        tag_value(shipment, "//ShipmentCharges/TransportationCharges/CurrencyCode", document, "currency")        
        tag_value(shipment, "//ShipmentCharges/TransportationCharges/MonetaryValue", document, "transportation_charges")        
        tag_value(shipment, "//ShipmentCharges/ServiceOptionsCharges/MonetaryValue", document, "service_options_charges")
        tag_value(shipment, "//ShipmentCharges/TotalCharges/MonetaryValue", document, "total_charges")                        
        tag_value(shipment, "//ShipmentIdentificationNumber", document, "shipment_identification_number")   
        tag_value(shipment, "//TrackingNumber", document, "tracking_number")                                        

        shipment
      end
      
      def parse_transit(response, document)
        summaries = document.xpath("//ServiceSummary")          
        
        summaries.each do |summary|
          s = UpsTransitSummary.new
          tag_value(s, "Service/Code", summary, "code")
          tag_value(s, "Service/Description", summary, "product_name")          
          tag_value(s, "EstimatedArrival/Time", summary, "time")          
          tag_value(s, "EstimatedArrival/PickupDate", summary, "pickup_date")
          tag_value(s, "EstimatedArrival/PickupTime", summary, "pickup_time")                              
          tag_value(s, "EstimatedArrival/Date", summary, "date")         
          tag_value(s, "EstimatedArrival/CustomerCenterCutoff", summary, "customer_cutoff")                   
          
          response.summaries << s                               
        end
        response
      end            
      
      def parse_tracking_response(document)
        response = UpsTrackingResponse.new
        parse_tracking_status(response, document)        
        #parse_tracking(response, document)                
        response
      end
      
      def parse_accept_response(document, shipment)
        tag_value(shipment, "//TrackingNumber", document, "tracking_number")    
        image_label = document.xpath("//LabelImage/GraphicImage")
          
        s = parse_accept_status(document, shipment)                                  
        s.label = image_label.text
        #puts "LABEL #{shipment.label}"
        s
      end            
      
      protected

        def parse_tracking_status(response, document)
          status = document.xpath("//TrackResponse/Response/ResponseStatusDescription")
          if status && status.text == "Success"
            response.success = true
          else
            response.success = false
          end
        end
        
        
        def parse_tracking(response, document)          
          tag_value(response, "//Shipment/Shipper/ShipperNumber", document, "shipper_number")
          tag_value(response, "//Shipment/ShipTo/Address/AddressLine1", document, "ship_to_addressline1")          
          tag_value(response, "//Shipment/ShipTo/Address/AddressLine2", document, "ship_to_addressline2")                    
          tag_value(response, "//Shipment/ShipTo/Address/City", document, "city")                              
          tag_value(response, "//Shipment/ShipTo/Address/StateProvinceCode", document, "state_province_code")                                        
          tag_value(response, "//Shipment/ShipTo/Address/PostalCode", document, "postal_code")                                        
          tag_value(response, "//Shipment/ShipTo/Address/CountryCode", document, "country_code")                                                            
          tag_value(response, "//Shipment/Service/Description", document, "description")                                                            
          tag_value(response, "//Shipment/Service/PickupDate", document, "pickup_date")                                                                      
          
          activities = document.xpath("//Activity")          
          
          activities.each do |activity|
             e = UpsTrackingEvent.new
             tag_value(e, "ActivityLocation/Address/City", activity, "city")
             tag_value(e, "ActivityLocation/Address/StateProvinceCode", activity, "state_province_code")             
             tag_value(e, "ActivityLocation/Address/PostalCode", activity, "postal_code")                          
             tag_value(e, "ActivityLocation/Address/CountryCode", activity, "country_code")                                       
             tag_value(e, "ActivityLocation/Code", activity, "code")                                                    
             tag_value(e, "ActivityLocation/Description", activity, "description")                                                                 
             tag_value(e, "ActivityLocation/SignedForByName", activity, "signed_for_by_name")                                                                              
             tag_value(e, "Status/StatusType/Code", activity, "status_type_code")                                                                                           
             tag_value(e, "Status/StatusType/Description", activity, "status_description")                                                                                                        
             tag_value(e, "Status/StatusCode/Code", activity, "status_code")
             tag_value(e, "Date", activity, "date")                                                                                                                                  
             tag_value(e, "Time", activity, "time")                                                                                                                                               
                                       
             response.tracking_events << e
           end                                                                                                                                     
        end                    

        def parse_confirm_status(document)
          success = true
          status = document.xpath("//ShipmentComfirmResponse/Response")
          
          status.each do |s|
            code = nil
            code = s.at('ResponseStatusCode').text if s.at('ResponseStatusCode')
            if code && code != "1"
              success = false
            end             
          end
          success        
        end
        
        def parse_transit_status(document)
          success = true
          status = document.xpath("//TimeInTransitResponse/Response")
          
          status.each do |s|
            code = nil
            code = s.at('ResponseStatusCode').text if s.at('ResponseStatusCode')
            if code && code != "1"
              success = false
            end             
          end
          success        
        end        
        
        def parse_accept_status(document, shipment)
          messages = []
          message = ""
          success = true
          status = document.xpath("//ShipmentAcceptResponse/Response")
          
          status.each do |s|
            code = nil
            code = s.at('ResponseStatusCode').text if s.at('ResponseStatusCode')
            if code && code != "1"
              success = false
              messages << s.at('//ErrorDescription').text
              messages << s.at('//ErrorCode').text              
              messages << s.at('//ErrorDescription').text                            
              
              message = messages.join(" ")
            end             
          end
          
          shipment.success = success
          shipment.message = message
          shipment       
        end        
                  
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
            
            quote.set_product_name
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
          url = test ? TEST_URL : LIVE_URL
          self.url = url
          ssl_post("#{url}/#{action}", request)
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