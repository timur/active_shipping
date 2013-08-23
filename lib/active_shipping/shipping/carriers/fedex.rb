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
      
      def ship(shipper, recipient, packages, options = {})
        packages = Array(packages)
        
        request = build_ship_request(shipper, recipient, packages, options)        
        response = commit(request)
        parse_ship_response(request, response)        
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
            
      def build_ship_request(shipper, recipient, packages, options = {})
        imperial = true
        xml_request = XmlNode.new('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 
                                                      'xmlns' => 'http://fedex.com/ws/ship/v12') do |root_node| 
          
          root_node << XmlNode.new('soapenv:Header')
          root_node << XmlNode.new('soapenv:Body') do |body|

            body << XmlNode.new('ProcessShipmentRequest') do |request|
              request << build_request_header

              # Version
              request << XmlNode.new('Version') do |version_node|
                version_node << XmlNode.new('ServiceId', 'ship')
                version_node << XmlNode.new('Major', '12')
                version_node << XmlNode.new('Intermediate', '0')
                version_node << XmlNode.new('Minor', '0')
              end
              
              request << XmlNode.new('RequestedShipment') do |ship_request|
                ship_request << XmlNode.new('ShipTimestamp', Time.now.utc.iso8601(2))                
                ship_request << XmlNode.new('DropoffType', 'REGULAR_PICKUP')
                ship_request << XmlNode.new('ServiceType', options[:service_code])                
                ship_request << XmlNode.new('PackagingType', 'YOUR_PACKAGING')       
                ship_request << XmlNode.new('PreferredCurrency', 'EUR')                       
                ship_request << shipper.fedex_xml
                ship_request << recipient.fedex_xml

                ship_request << XmlNode.new('ShippingChargesPayment') do |charge|
                  charge << XmlNode.new('PaymentType', 'SENDER')
                  charge << XmlNode.new('Payor') do |payor|
                    payor << XmlNode.new('ResponsibleParty') do |party|
                      party << XmlNode.new('AccountNumber', options[:account_number])
                      party << XmlNode.new('Contact') do |contact|                      
                        contact << XmlNode.new('PersonName', shipper.contact.person_name)
                        contact << XmlNode.new('CompanyName', shipper.contact.company_name)
                        contact << XmlNode.new('PhoneNumber', shipper.contact.phone_number)                                                
                      end
                    end
                  end                  
                end
                
                ship_request << XmlNode.new('LabelSpecification') do |label_spec|
                  label_spec << XmlNode.new('LabelFormatType', 'COMMON2D')
                  label_spec << XmlNode.new('ImageType', 'PDF')
                  label_spec << XmlNode.new('LabelStockType', 'PAPER_LETTER')                                    
                end                

                ship_request << XmlNode.new('RateRequestTypes', 'ACCOUNT')                  
                ship_request << XmlNode.new('PackageCount', packages.size)                
                    
                packages.each do |pkg|
                  ship_request << XmlNode.new('RequestedPackageLineItems') do |rps|
                    rps << XmlNode.new('GroupPackageCount', 1)
                    rps << XmlNode.new('Weight') do |tw|
                      tw << XmlNode.new('Units', imperial ? 'LB' : 'KG')
                      tw << XmlNode.new('Value', [((imperial ? pkg.lbs : pkg.kgs).to_f*1000).round/1000.0, 0.1].max)
                    end
                    rps << XmlNode.new('Dimensions') do |dimensions|
                      [:length,:width,:height].each do |axis|
                        value = ((imperial ? pkg.inches(axis) : pkg.cm(axis)).to_f*1000).round/1000.0 # 3 decimals
                        dimensions << XmlNode.new(axis.to_s.capitalize, value.ceil)
                      end
                      dimensions << XmlNode.new('Units', imperial ? 'IN' : 'CM')
                    end
                  end
                end                        
              end  
            end
          end
        end
        xml_request.to_s
      end
      
      
      def parse_ship_response(request, response)
        rate_estimates = []
        success, message, imagecoded, tr = nil

        xml = REXML::Document.new(response)

        success = response_success?(xml, 'http://fedex.com/ws/ship/v12')
        message = response_message(xml, 'http://fedex.com/ws/ship/v12')        

        shipment_label = REXML::XPath.match(xml, "//version:Label", 'version' => 'http://fedex.com/ws/ship/v12' )        
        parts = REXML::XPath.match( shipment_label, "//version:Parts", 'version' => 'http://fedex.com/ws/ship/v12' )        

        images = REXML::XPath.match( parts, "//version:Image", 'version' => 'http://fedex.com/ws/ship/v12' )        
        imagecoded = images[0].get_text if images.size > 0
        
        image = Base64.decode64(imagecoded.to_s) if imagecoded
        
        details = REXML::XPath.match( parts, "//version:CompletedPackageDetails", 'version' => 'http://fedex.com/ws/ship/v12' )                
        sequence = REXML::XPath.match( parts, "//version:SequenceNumber", 'version' => 'http://fedex.com/ws/ship/v12' )                                
        ids = REXML::XPath.match( details, "//version:TrackingIds", 'version' => 'http://fedex.com/ws/ship/v12' )                  
        
        tracking_number = REXML::XPath.match( ids, "//version:TrackingNumber", 'version' => 'http://fedex.com/ws/ship/v12')          
        tr = tracking_number[0].get_text.to_s if tracking_number.size > 0
        
        ShipResponse.new(success, message, request: request, response: response, tracking_number: tr, imagecoded: image)        
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
