require 'nokogiri'

module ActiveMerchant
  module Shipping

    class Dhl < Carrier
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants     
      
      attr_reader :site_id, :password      
      attr_accessor :url

      self.retry_safe = true

      cattr_reader :name
      @@name = "DHL"

      TEST_URL = 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
      LIVE_URL = 'https://xmlpi-ea.dhl.com/XMLShippingServlet'      
      
      def find_quotes(options = {})
        call_method(options, "parse_quote_response")
      end
      
      def shipment(options = {})
        call_method(options, "parse_shipment_response")        
      end  
      
      def tracking(options = {})
        call_method(options, "parse_tracking_response")                
      end    
      
      def book_pickup(options = {})
        call_method(options, "parse_pickup_response")
      end
      
      def cancel_pickup(options = {})
        call_method(options, "parse_cancel_pickup_response")
      end
      
      def modify_pickup(options = {})
        call_method(options, "parse_pickup_response")
      end                        

      def parse_shipment_response(document, options)
        response = DhlShipmentResponse.new
        parse_status_notes(response, document)        
        parse_notes(response, document)
        parse_shipment(response, document)        
        response
      end
      
      def parse_tracking_response(document, options)
        response = DhlTrackingResponse.new
        parse_tracking_status(response, document)
        parse_tracking(response, document)        
        response
      end      
            
      def parse_quote_response(document, options)
        response = DhlQuoteResponse.new
        response.success = parse_status(document)
        parse_notes(response, document)
        parse_quotes(response, document, options)        
        response
      end
      
      def parse_pickup_response(document, options)
        response = DhlBookPickupResponse.new
        parse_pickup_status(response, document)
        parse_pickup(response, document)    
        response
      end
      
      def parse_cancel_pickup_response(document, options)
        response = DhlCancelPickupResponse.new
        parse_pickup_status(response, document)
        response
      end            

      private
        
        def call_method(options, method)
          xml = ""
          if options[:raw_xml]
            xml = File.open(Dir.pwd + "/test/fixtures/xml/dhl/#{options[:raw_xml]}").read
          elsif options[:raw_string]
            xml = options[:raw_string]
          else
            request = options[:request]        
            request.site_id = @options[:site_id]
            request.password = @options[:password]        
            xml = request.to_xml
          end

          response_raw = commit(save_request(xml), (options[:test] || false))                     
          resp = send(method, Nokogiri::XML(response_raw), options)

          resp.response = response_raw
          resp.request = last_request
          resp          
        end
        
        def commit(request, test = false)
          url = self.test_mode ? TEST_URL : LIVE_URL
          self.url = url
          ssl_post(url, request.gsub("\n",''))
        end
        
        def parse_shipment(response, document)
          tag_value(response, "//AirwayBillNumber", document, "airwaybillnumber")
          tag_value(response, "//Rated", document, "rated")          
          tag_value(response, "//ChargeableWeight", document, "chargable_weight")          
          tag_value(response, "//DimensionalWeight", document, "dimensional_weight")                              
          tag_value(response, "//CustomerID", document, "customer_id")                                        
          tag_value(response, "//LabelImage//OutputImage", document, "label")   
          tag_value(response, "//ShipmentDate", document, "shipment_date")             
          tag_value(response, "//ProductShortName", document, "product_name")             
          tag_value(response, "//DeliveryTimeCode", document, "delivery_time_code")             

          tag_value(response, "//Shipper//CompanyName", document, "shipper_company")    
          tag_value(response, "//Shipper//AddressLine", document, "shipper_address_line")    
          tag_value(response, "//Shipper//CountryCode", document, "shipper_countrycode")                        
          tag_value(response, "//Shipper//PostalCode", document, "shipper_postalcode")                                  
          tag_value(response, "//Shipper//City", document, "shipper_city")                                  
          tag_value(response, "//Shipper//RegisteredAccount", document, "shipper_registered_account")                                                      
          tag_value(response, "//Shipper//Contact//PersonName", document, "contact_shipper_fullname")                                                      
          tag_value(response, "//Shipper//Contact//PhoneNumber", document, "contact_shipper_phonenumber")                                                      
          tag_value(response, "//Shipper//Contact//PhoneExtension", document, "contact_shipper_phoneext")                                                                                    
          
          tag_value(response, "//Consignee//CompanyName", document, "consignee_company")    
          tag_value(response, "//Consignee//AddressLine", document, "consignee_address_line")    
          tag_value(response, "//Consignee//CountryCode", document, "consignee_countrycode")                        
          tag_value(response, "//Consignee//PostalCode", document, "consignee_postalcode")                                  
          tag_value(response, "//Consignee//City", document, "consignee_city")                                  
          tag_value(response, "//Consignee//RegisteredAccount", document, "consignee_registered_account")                                                      
          tag_value(response, "//Consignee//Contact//PersonName", document, "contact_consignee_fullname")                                                      
          tag_value(response, "//Consignee//Contact//PhoneNumber", document, "contact_consignee_phonenumber")                                                      
          tag_value(response, "//Consignee//Contact//PhoneExtension", document, "contact_consignee_phoneext")                                                                                              
        end
        
        def parse_tracking(response, document)
          tag_value(response, "//ShipmentInfo/OriginServiceArea/ServiceAreaCode", document, "origin_service_area_code")
          tag_value(response, "//ShipmentInfo/OriginServiceArea/Description", document, "origin_description")
          tag_value(response, "//ShipmentInfo/DestinationServiceArea/ServiceAreaCode", document, "destination_service_area_code")
          tag_value(response, "//ShipmentInfo/DestinationServiceArea/Description", document, "destination_description")
          tag_value(response, "//ShipmentInfo/ShipperName", document, "shipper_name")
          tag_value(response, "//ShipmentInfo/ShipperAccountNumber", document, "shipper_account_number")
          tag_value(response, "//ShipmentInfo/ConsigneeName", document, "consignee_name")
          tag_value(response, "//ShipmentInfo/ShipmentDate", document, "shipment_date")          
          tag_value(response, "//ShipmentInfo/ShipmentDesc", document, "shipment_description")                    
          tag_value(response, "//ShipmentInfo/Shipper/City", document, "shipper_city")                    
          tag_value(response, "//ShipmentInfo/Shipper/CountryCode", document, "shipper_countrycode")                              
          tag_value(response, "//ShipmentInfo/Consignee/City", document, "consignee_city")                    
          tag_value(response, "//ShipmentInfo/Consignee/PostalCode", document, "consignee_postalcode")                              
          tag_value(response, "//ShipmentInfo/Consignee/CountryCode", document, "consignee_countrycode")                                        
          tag_value(response, "//ShipmentInfo/ShipperReference/ReferenceID", document, "shipper_referenceid")

          events = document.xpath("//ShipmentEvent")          
          
          events.each do |event|
             e = DhlTrackingEvent.new
             tag_value_relative(e, "Date", event, "date")
             tag_value_relative(e, "time", event, "time")
             tag_value_relative(e, "ServiceEvent/EventCode", event, "event_code")          
             tag_value_relative(e, "ServiceEvent/Description", event, "event_description")                    
             tag_value_relative(e, "ServiceArea/ServiceAreaCode", event, "service_area_code")                    
             tag_value_relative(e, "ServiceArea/Description", event, "service_area_description")                    
                                       
             response.tracking_events << e
           end                                                                                                                                     
        end  
        
        def parse_pickup(response, document)
          tag_value(response, "//ConfirmationNumber", document, "confirmation_number")
          tag_value(response, "//ReadyByTime", document, "ready_by_time")
          tag_value(response, "//NextPickupDate", document, "next_pickup_date")
          tag_value(response, "//OriginSvcArea", document, "origin_area")          
          
          error_array = []
          errors = document.xpath("//Condition")          
          
          errors.each do |error|
            tag = error.xpath("//ConditionData")
            error_array << tag.text if tag
          end                               
          
          response.error_messages = error_array                                                                                                      
        end              
        
        def parse_quotes(response, document, options)
          international = false
          
          if options.has_key? :international
            international = options[:international]
          end
          
          quotes = document.xpath("//QtdShp")
          
          quotes.each do |qtdshp|
            q = DhlQuote.new
            
            q.pickup_date = qtdshp.at('PickupDate').text if qtdshp.at('PickupDate')
            q.global_product_code = qtdshp.at('GlobalProductCode').text if qtdshp.at('GlobalProductCode')
            q.local_product_code = qtdshp.at('LocalProductCode').text if qtdshp.at('LocalProductCode')          
            q.local_product_name = qtdshp.at('ProductShortName').text if qtdshp.at('ProductShortName')
            q.product_short_name = qtdshp.at('LocalProductName').text if qtdshp.at('LocalProductName')          
            q.delivery_date = qtdshp.at('DeliveryDate').text if qtdshp.at('DeliveryDate')          
            q.delivery_time = qtdshp.at('DeliveryTime').text if qtdshp.at('DeliveryTime')          
            q.transit_days = qtdshp.at('TotalTransitDays').text if qtdshp.at('TotalTransitDays')          
            q.pickup_day_of_week = qtdshp.at('PickupDayOfWeekNum').text if qtdshp.at('PickupDayOfWeekNum')          
            q.destination_day_of_week = qtdshp.at('DestinationDayOfWeekNum').text if qtdshp.at('DestinationDayOfWeekNum')          
            q.product_short_name = qtdshp.at('LocalProductName').text if qtdshp.at('LocalProductName')                    
            q.pickup_date_cutoff_time = qtdshp.at('PickupCutoffTime').text if qtdshp.at('PickupCutoffTime')          
            q.booking_time = qtdshp.at('BookingTime').text if qtdshp.at('BookingTime')          
            q.currency = qtdshp.at('CurrencyCode').text if qtdshp.at('CurrencyCode')          
            q.exchange_rate = qtdshp.at('ExchangeRate').text if qtdshp.at('ExchangeRate')
            q.pricing_date = qtdshp.at('PricingDate').text if qtdshp.at('PricingDate')   
            q.total_charge = qtdshp.at('ShippingCharge').text if qtdshp.at('ShippingCharge') 
            if international
              q.weight_charge = qtdshp.at('WeightChargeTaxDet//BaseAmt').text if qtdshp.at('WeightChargeTaxDet//BaseAmt')               
            else  
              q.weight_charge = qtdshp.at('WeightChargeTaxDet//BaseAmt').text if qtdshp.at('WeightChargeTaxDet//BaseAmt')               
            end
            q.weight_charge_tax = qtdshp.at('WeightChargeTax').text if qtdshp.at('WeightChargeTax')                                       
            q.total_tax_amount = qtdshp.at('TotalTaxAmount').text if qtdshp.at('TotalTaxAmount')  
                        
            parse_extra_charges(qtdshp, q)                                                                   
            
            q.calculate 
            
            if q.total_charge > 0
              response.quotes << q
            end
          end        
        end
        
        def parse_tracking_status(response, document)
          status = document.xpath("//ActionStatus")          
          if status && status.text == "success"          
            response.success = true 
          end
        end
        
        def parse_pickup_status(response, document)
          status = document.xpath("//Note/ActionNote")   
          if status && status.text.casecmp("success") == 0
            response.success = true 
          end
          status = document.xpath("//Status/ActionStatus")   
          if status && status.text.casecmp("error") == 0
            response.success = false 
          end
        end                
        
        def parse_notes(response, document)
          notes = document.xpath("//Note")
          
          notes.each do |note|
            n = DhlNote.new
            condition = note.xpath("Condition")
            n.code = condition.at('ConditionCode').text if note.at('ConditionCode')
            n.data = condition.at('ConditionData').text if note.at('ConditionData')          

            action = note.xpath("ActionNote")
            if action
              n.action_code = action.text
            end
            response.notes << n
          end        
        end

        def parse_status_notes(response, document)
          status = document.xpath("//Status")
          
          condition = status.xpath("Condition")
          if condition
            n = DhlNote.new            
            n.code = condition.at('ConditionCode').text if condition.at('ConditionCode')
            n.data = condition.at('ConditionData').text if condition.at('ConditionData')    
            response.notes << n
          end            
        end
                
        def parse_status(document)
          success = true
          status = document.xpath("//Status")
          
          status.each do |s|
            action = nil
            action = s.at('ActionStatus').text if s.at('ActionStatus')
            if action && action == "Error"
              success = false
            end             
          end
          success        
        end        
        
        def parse_extra_charges(quote_node, dhl_quote)
          extras = quote_node.xpath("QtdShpExChrg")
          
          extras.each do |extra|
            e = DhlExtraCharge.new
            
            e.special_service_type = extra.at('SpecialServiceType').text if extra.at('SpecialServiceType')
            e.local_service_type = extra.at('LocalServiceType').text if extra.at('LocalServiceType')
            e.global_service_name = extra.at('GlobalServiceName').text if extra.at('GlobalServiceName')
            
            e.local_service_name = extra.at('LocalServiceTypeName').text if extra.at('LocalServiceTypeName')                              
            e.currency = extra.at('CurrencyCode').text if extra.at('CurrencyCode')                              
            e.charge_value = extra.at('ChargeTaxAmountDet//BaseAmount').text if extra.at('ChargeTaxAmountDet//BaseAmount')                              
            e.charge_tax_amount = extra.at('ChargeTaxAmount').text if extra.at('ChargeTaxAmount')                                        
            
            if e.charge_value
              dhl_quote.extra_charges << e                  
            end
          end        
        end
        
        def tag_value(response, xml_tag, document, attribute)
          tag = document.xpath("//#{xml_tag}")          
          response.send("#{attribute}=", tag.text) if tag          
        end
        
        def tag_value_relative(object, xml_tag, document, attribute)
          tag = document.xpath("#{xml_tag}")   
          object.send("#{attribute}=", tag.text) if tag          
        end
        
    end
  end
end