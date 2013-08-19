require 'nokogiri'

module ActiveMerchant
  module Shipping

    class Dhl < Carrier
      self.retry_safe = true

      cattr_reader :name
      @@name = "DHL"

      TEST_URL = 'https://xmlpitest-ea.dhl.com/XMLShippingServlet'
      LIVE_URL = 'https://xmlpi-ea.dhl.com/XMLShippingServlet'
      
      PackageTypes = {
        "EE" => "DHL Express Envelope",
        "OD" => "Other DHL Packaging",
        "CP" => "Custom Packaging",
        "DC" => "Document",
        "DM" => "Domestic",
        "ED" => "Express Document",
        "FR" => "Freight",
        "BD" => "Jumbo Document",
        "BP" => "Jumbo Parcel",
        "JD" => "Jumbo Junior Document",
        "JP" => "Jumbo Junior Parcel",
        "PA" => "Parcel",
        "DF" => "DHL Flyer"
      }
      PaymentTypes = {
        'shipper' => 'S',
        'receiver' => 'R',
        'third_party' => 'T'
      }

      GlobalProductCodes = {
        "0"	=> "LOGISTICS SERVICES",
        "1"	=> "CUSTOMS SERVICES",
        "2"	=> "EASY SHOP",
        "3"	=> "EASY SHOP",
        "4"	=> "JETLINE",
        "5"	=> "SPRINTLINE",
        "6"	=> "SECURELINE",
        "7"	=> "EXPRESS EASY",
        "8"	=> "EXPRESS EASY",
        "9"	=> "EUROPACK",
        "A"	=> "AUTO REVERSALS",
        "B"	=> "BREAK BULK EXPRESS",
        "C"	=> "MEDICAL EXPRESS",
        "D"	=> "EXPRESS WORLDWIDE",
        "E"	=> "EXPRESS 9:00",
        "F"	=> "FREIGHT WORLDWIDE",
        "G"	=> "DOMESTIC ECONOMY SELECT",
        "H"	=> "ECONOMY SELECT",
        "I"	=> "BREAK BULK ECONOMY",
        "J"	=> "JUMBO BOX",
        "K"	=> "EXPRESS 9:00",
        "L"	=> "EXPRESS 10:30",
        "M"	=> "EXPRESS 10:30",
        "N"	=> "DOMESTIC EXPRESS",
        "O"	=> "OTHERS",
        "P"	=> "EXPRESS WORLDWIDE",
        "Q"	=> "MEDICAL EXPRESS",
        "R"	=> "GLOBALMAIL BUSINESS",
        "S"	=> "SAME DAY",
        "T"	=> "EXPRESS 12:00",
        "U"	=> "EXPRESS WORLDWIDE",
        "V"	=> "EUROPACK",
        "W"	=> "ECONOMY SELECT",
        "X"	=> "EXPRESS ENVELOPE",
        "Y"	=> "EXPRESS 12:00",
        "Z"	=> "Destination Charges"


      }

      DHL_Currency_Codes = {
        "AD"	=>     "EUR",
        "AE"	=>     "AED",
        "AF"	=>     "AFN",
        "AG"	=>     "XCD",
        "AI"	=>     "XCD",
        "AL"	=>     "EUR",
        "AM"	=>     "AMD",
        "AN"	=>     "ANG",
        "AO"	=>     "AOA",
        "AR"	=>     "ARS",
        "AS"	=>     "USD",
        "AT"	=>     "EUR",
        "AU"	=>     "AUD",
        "AW"	=>     "AWG",
        "AZ"	=>     "AZM",
        "BA"	=>     "BAM",
        "BB"	=>     "BBD",
        "BD"	=>     "BDT",
        "BE"	=>     "EUR",
        "BF"	=>     "XOF",
        "BG"	=>     "BGN",
        "BH"	=>     "BHD",
        "BI"	=>     "BIF",
        "BJ"	=>     "XOF",
        "BM"	=>     "BMD",
        "BN"	=>     "BND",
        "BO"	=>     "BOB",
        "BR"	=>     "BRL",
        "BS"	=>     "BSD",
        "BT"	=>     "BTN",
        "BW"	=>     "BWP",
        "BY"	=>     "BYR",
        "BZ"	=>     "BZD",
        "CA"	=>     "CAD",
        "CD"	=>     "CDF",
        "CF"	=>     "XAF",
        "CG"	=>     "XAF",
        "CH"	=>     "CHF",
        "CI"	=>     "XOF",
        "CK"	=>     "NZD",
        "CL"	=>     "CLP",
        "CM"	=>     "XAF",
        "CN"	=>     "CNY",
        "CO"	=>     "COP",
        "CR"	=>     "CRC",
        "CU"	=>     "CUP",
        "CV"	=>     "CVE",
        "CY"	=>     "EUR",
        "CZ"	=>     "CZK",
        "DE"	=>     "EUR",
        "DJ"	=>     "DJF",
        "DK"	=>     "DKK",
        "DM"	=>     "XCD",
        "DO"	=>     "DOP",
        "DZ"	=>     "DZD",
        "EC"	=>     "USD",
        "EE"	=>     "EEK",
        "EG"	=>     "EGP",
        "ER"	=>     "ERN",
        "ES"	=>     "EUR",
        "ET"	=>     "ETB",
        "FI"	=>     "EUR",
        "FJ"	=>     "FJD",
        "FK"	=>     "FKP",
        "FM"	=>     "USD",
        "FO"	=>     "DKK",
        "FR"	=>     "EUR",
        "GA"	=>     "XAF",
        "GB"	=>     "GBP",
        "GD"	=>     "XCD",
        "GE"	=>     "GEL",
        "GF"	=>     "EUR",
        "GG"	=>     "GBP",
        "GH"	=>     "GHS",
        "GI"	=>     "GIP",
        "GL"	=>     "DKK",
        "GM"	=>     "GMD",
        "GN"	=>     "GNF",
        "GP"	=>     "EUR",
        "GQ"	=>     "XAF",
        "GR"	=>     "EUR",
        "GT"	=>     "GTQ",
        "GU"	=>     "USD",
        "GW"	=>     "GWP",
        "GY"	=>     "GYD",
        "HK"	=>     "HKD",
        "HN"	=>     "HNL",
        "HR"	=>     "HRK",
        "HT"	=>     "HTG",
        "HU"	=>     "HUF",
        "IC"	=>     "EUR",
        "ID"	=>     "IDR",
        "IE"	=>     "EUR",
        "IL"	=>     "ILS",
        "IN"	=>     "INR",
        "IQ"	=>     "IQD",
        "IR"	=>     "IRR",
        "IS"	=>     "ISK",
        "IT"	=>     "EUR",
        "JE"	=>     "GBP",
        "JM"	=>     "JMD",
        "JO"	=>     "JOD",
        "JP"	=>     "JPY",
        "KE"	=>     "KES",
        "KG"	=>     "KGS",
        "KH"	=>     "KHR",
        "KI"	=>     "AUD",
        "KM"	=>     "KMF",
        "KN"	=>     "XCD",
        "KP"	=>     "KPW",
        "KR"	=>     "KRW",
        "KV"	=>     "EUR",
        "KW"	=>     "KWD",
        "KY"	=>     "KYD",
        "KZ"	=>     "KZT",
        "LA"	=>     "LAK",
        "LB"	=>     "USD",
        "LC"	=>     "XCD",
        "LI"	=>     "CHF",
        "LK"	=>     "LKR",
        "LR"	=>     "LRD",
        "LS"	=>     "LSL",
        "LT"	=>     "LTL",
        "LU"	=>     "EUR",
        "LV"	=>     "LVL",
        "LY"	=>     "LYD",
        "MA"	=>     "MAD",
        "MC"	=>     "EUR",
        "MD"	=>     "MDL",
        "ME"	=>     "EUR",
        "MG"	=>     "MGA",
        "MH"	=>     "USD",
        "MK"	=>     "MKD",
        "ML"	=>     "XOF",
        "MM"	=>     "USD",
        "MN"	=>     "MNT",
        "MO"	=>     "MOP",
        "MP"	=>     "USD",
        "MQ"	=>     "EUR",
        "MR"	=>     "MRO",
        "MS"	=>     "XCD",
        "MT"	=>     "EUR",
        "MU"	=>     "MUR",
        "MV"	=>     "MVR",
        "MW"	=>     "MWK",
        "MX"	=>     "MXN",
        "MY"	=>     "MYR",
        "MZ"	=>     "MZN",
        "NA"	=>     "ZAR",
        "NC"	=>     "XPF",
        "NE"	=>     "XOF",
        "NG"	=>     "NGN",
        "NI"	=>     "NIO",
        "NL"	=>     "EUR",
        "NO"	=>     "NOK",
        "NP"	=>     "NPR",
        "NR"	=>     "AUD",
        "NU"	=>     "NZD",
        "NZ"	=>     "NZD",
        "OM"	=>     "OMR",
        "PA"	=>     "PAB",
        "PE"	=>     "PEN",
        "PF"	=>     "XPF",
        "PG"	=>     "PGK",
        "PH"	=>     "PHP",
        "PK"	=>     "PKR",
        "PL"	=>     "PLN",
        "PR"	=>     "USD",
        "PT"	=>     "EUR",
        "PW"	=>     "USD",
        "PY"	=>     "PYG",
        "QA"	=>     "QAR",
        "RE"	=>     "EUR",
        "RO"	=>     "RON",
        "RS"	=>     "RSD",
        "RU"	=>     "RUB",
        "RW"	=>     "RWF",
        "SA"	=>     "SAR",
        "SB"	=>     "SBD",
        "SC"	=>     "SCR",
        "SD"	=>     "SDG",
        "SE"	=>     "SEK",
        "SG"	=>     "SGD",
        "SI"	=>     "EUR",
        "SK"	=>     "EUR",
        "SL"	=>     "SLL",
        "SM"	=>     "EUR",
        "SN"	=>     "XOF",
        "SO"	=>     "SOS",
        "SR"	=>     "SRD",
        "ST"	=>     "STD",
        "SV"	=>     "USD",
        "SY"	=>     "SYP",
        "SZ"	=>     "SZL",
        "TC"	=>     "USD",
        "TD"	=>     "XAF",
        "TG"	=>     "XOF",
        "TH"	=>     "THB",
        "TJ"	=>     "TJS",
        "TL"	=>     "USD",
        "TN"	=>     "TND",
        "TO"	=>     "TOP",
        "TR"	=>     "TRY",
        "TT"	=>     "TTD",
        "TV"	=>     "AUD",
        "TW"	=>     "TWD",
        "TZ"	=>     "TZS",
        "UA"	=>     "UAH",
        "UG"	=>     "UGX",
        "US"	=>     "USD",
        "UY"	=>     "UYU",
        "UZ"	=>     "UZS",
        "VC"	=>     "XCD",
        "VE"	=>     "VEF",
        "VG"	=>     "USD",
        "VI"	=>     "USD",
        "VN"	=>     "VND",
        "VU"	=>     "VUV",
        "WS"	=>     "WST",
        "XB"	=>     "EUR",
        "XC"	=>     "EUR",
        "XE"	=>     "ANG",
        "XM"	=>     "EUR",
        "XN"	=>     "XCD",
        "XS"	=>     "SIS",
        "XY"	=>     "ANG",
        "YE"	=>     "YER",
        "YT"	=>     "EUR",
        "ZA"	=>     "ZAR",
        "ZM"	=>     "ZMK",
        "ZW"	=>     "ZWD"
      }

      DoorTo = {
        'DD' => "Door to Door",
        'DA' => "Door to Airport",
        'AA' => 'Door to Dor non-compliant',
        'AA' => 'Door to Dor non-compliant'
      }

      def requirements
        [:site_id, :password, :test]
      end

      def find_quotes(options = {})
        pieces = options[:pieces]
        request = options[:request]
        
        request.site_id = @options[:site_id]
        request.password = @options[:password]        

        response_raw = commit(save_request(request.to_xml), (options[:test] || false))             
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
        parse_notes(response, document)
        parse_quotes(response, document)
        
        response
      end

      protected

        def commit(request, test = false)
          ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))
        end
        
        private
        
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
            q.shipping_charge = qtdshp.at('ShippingCharge').text if qtdshp.at('ShippingCharge')   
            q.total_tax_amount = qtdshp.at('TotalTaxAmount').text if qtdshp.at('TotalTaxAmount')   
            
            parse_extra_charges(qtdshp, q)                                                                   
        
            if q.shipping_charge > 0
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