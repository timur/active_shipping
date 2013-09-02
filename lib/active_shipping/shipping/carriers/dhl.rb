require 'nokogiri'

module ActiveMerchant
  module Shipping

    class Dhl < Carrier
      include ActiveMerchant::Shipping::DhlConstants
      include ActiveMerchant::Shipping::Constants      

      self.retry_safe = true

      cattr_reader :name
      @@name = "DHL"

      TEST_URL = 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
      LIVE_URL = 'https://xmlpi-ea.dhl.com/XMLShippingServlet'
      
      
      def find_quotes(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/dhl/#{options[:raw_xml]}").read
        else        
          pieces = options[:pieces]
          request = options[:request]
          
          request.site_id = @options[:site_id]
          request.password = @options[:password]        
          
          xml = request.to_xml
        end
        response_raw = commit(save_request(xml), (options[:test] || false))             
        resp = parse_quote_response(Nokogiri::XML(response_raw))
        resp.response = response_raw
        resp.request = last_request
        resp
      end
      
      def shipment(options = {})
        xml = ""
        if options[:raw_xml]
          xml = File.open(Dir.pwd + "/test/fixtures/xml/dhl/#{options[:raw_xml]}").read
        else
          pieces = options[:pieces]
          request = options[:request]
        
          request.site_id = @options[:site_id]
          request.password = @options[:password]        
          xml = request.to_xml
        end
        
        response_raw = commit(save_request(xml), (options[:test] || false))                     
        resp = parse_shipment_response(Nokogiri::XML(response_raw))
        
        resp.response = response_raw
        resp.request = last_request
        resp
      end      

      def parse_shipment_response(document)
        response = DhlShipmentResponse.new
        parse_notes(response, document)
        parse_shipment(response, document)
        
        response
      end
            
      def parse_quote_response(document)
        response = DhlQuoteResponse.new
        response.success = parse_status(document)
        parse_notes(response, document)
        parse_quotes(response, document)
        
        response
      end

      private

        def commit(request, test = false)
          ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))
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
        
        def parse_quotes(response, document)
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
            q.weight_charge = qtdshp.at('WeightCharge').text if qtdshp.at('WeightCharge')               
            q.weight_charge_tax = qtdshp.at('WeightChargeTax').text if qtdshp.at('WeightChargeTax')                                       
            q.total_tax_amount = qtdshp.at('TotalTaxAmount').text if qtdshp.at('TotalTaxAmount')  
                        
            parse_extra_charges(qtdshp, q)                                                                   
            
            q.calculate 
            
            if q.total_charge > 0
              response.quotes << q
            end
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
            e.charge_value = extra.at('ChargeValue').text if extra.at('ChargeValue')                              
            e.charge_tax_amount = extra.at('ChargeTaxAmount').text if extra.at('ChargeTaxAmount')                                        
            
            dhl_quote.extra_charges << e                  
          end        
        end
        
        def tag_value(response, xml_tag, document, attribute)
          tag = document.xpath("//#{xml_tag}")          
          response.send("#{attribute}=", tag.text) if tag          
        end
    end
  end
end