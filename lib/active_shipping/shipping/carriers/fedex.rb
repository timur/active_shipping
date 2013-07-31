# FedEx module by Jimmy Baker
# http://github.com/jimmyebaker

require 'date'
require 'base64'
require 'pathname'

module ActiveMerchant
  module Shipping
    
    # :key is your developer API key
    # :password is your API password
    # :account is your FedEx account number
    # :login is your meter number
    class FedEx < Carrier
      self.retry_safe = true
      
      cattr_reader :name
      @@name = "FedEx"
      
      #TEST_URL = 'https://gatewaybeta.fedex.com:443/xml'
      
      TEST_URL = 'https://wsbeta.fedex.com:443/web-services'            
      LIVE_URL = 'https://gateway.fedex.com:443/xml'
      
      CarrierCodes = {
        "fedex_ground" => "FDXG",
        "fedex_express" => "FDXE"
      }
      
      ServiceTypes = {
        "PRIORITY_OVERNIGHT" => "FedEx Priority Overnight",
        "PRIORITY_OVERNIGHT_SATURDAY_DELIVERY" => "FedEx Priority Overnight Saturday Delivery",
        "FEDEX_2_DAY" => "FedEx 2 Day",
        "FEDEX_2_DAY_SATURDAY_DELIVERY" => "FedEx 2 Day Saturday Delivery",
        "STANDARD_OVERNIGHT" => "FedEx Standard Overnight",
        "FIRST_OVERNIGHT" => "FedEx First Overnight",
        "FIRST_OVERNIGHT_SATURDAY_DELIVERY" => "FedEx First Overnight Saturday Delivery",
        "FEDEX_EXPRESS_SAVER" => "FedEx Express Saver",
        "FEDEX_1_DAY_FREIGHT" => "FedEx 1 Day Freight",
        "FEDEX_1_DAY_FREIGHT_SATURDAY_DELIVERY" => "FedEx 1 Day Freight Saturday Delivery",
        "FEDEX_2_DAY_FREIGHT" => "FedEx 2 Day Freight",
        "FEDEX_2_DAY_FREIGHT_SATURDAY_DELIVERY" => "FedEx 2 Day Freight Saturday Delivery",
        "FEDEX_3_DAY_FREIGHT" => "FedEx 3 Day Freight",
        "FEDEX_3_DAY_FREIGHT_SATURDAY_DELIVERY" => "FedEx 3 Day Freight Saturday Delivery",
        "INTERNATIONAL_PRIORITY" => "FedEx International Priority",
        "INTERNATIONAL_PRIORITY_SATURDAY_DELIVERY" => "FedEx International Priority Saturday Delivery",
        "INTERNATIONAL_ECONOMY" => "FedEx International Economy",
        "INTERNATIONAL_FIRST" => "FedEx International First",
        "INTERNATIONAL_PRIORITY_FREIGHT" => "FedEx International Priority Freight",
        "INTERNATIONAL_ECONOMY_FREIGHT" => "FedEx International Economy Freight",
        "GROUND_HOME_DELIVERY" => "FedEx Ground Home Delivery",
        "FEDEX_GROUND" => "FedEx Ground",
        "INTERNATIONAL_GROUND" => "FedEx International Ground"
      }

      PackageTypes = {
        "fedex_envelope" => "FEDEX_ENVELOPE",
        "fedex_pak" => "FEDEX_PAK",
        "fedex_box" => "FEDEX_BOX",
        "fedex_tube" => "FEDEX_TUBE",
        "fedex_10_kg_box" => "FEDEX_10KG_BOX",
        "fedex_25_kg_box" => "FEDEX_25KG_BOX",
        "your_packaging" => "YOUR_PACKAGING"
      }

      DropoffTypes = {
        'regular_pickup' => 'REGULAR_PICKUP',
        'request_courier' => 'REQUEST_COURIER',
        'dropbox' => 'DROP_BOX',
        'business_service_center' => 'BUSINESS_SERVICE_CENTER',
        'station' => 'STATION'
      }

      PaymentTypes = {
        'sender' => 'SENDER',
        'recipient' => 'RECIPIENT',
        'third_party' => 'THIRDPARTY',
        'collect' => 'COLLECT'
      }
      
      PackageIdentifierTypes = {
        'tracking_number' => 'TRACKING_NUMBER_OR_DOORTAG',
        'door_tag' => 'TRACKING_NUMBER_OR_DOORTAG',
        'rma' => 'RMA',
        'ground_shipment_id' => 'GROUND_SHIPMENT_ID',
        'ground_invoice_number' => 'GROUND_INVOICE_NUMBER',
        'ground_customer_reference' => 'GROUND_CUSTOMER_REFERENCE',
        'ground_po' => 'GROUND_PO',
        'express_reference' => 'EXPRESS_REFERENCE',
        'express_mps_master' => 'EXPRESS_MPS_MASTER'
      }


      TransitTimes = ["UNKNOWN","ONE_DAY","TWO_DAYS","THREE_DAYS","FOUR_DAYS","FIVE_DAYS","SIX_DAYS","SEVEN_DAYS","EIGHT_DAYS","NINE_DAYS","TEN_DAYS","ELEVEN_DAYS","TWELVE_DAYS","THIRTEEN_DAYS","FOURTEEN_DAYS","FIFTEEN_DAYS","SIXTEEN_DAYS","SEVENTEEN_DAYS","EIGHTEEN_DAYS"]

      # FedEx tracking codes as described in the FedEx Tracking Service WSDL Guide
      # All delays also have been marked as exceptions
      TRACKING_STATUS_CODES = HashWithIndifferentAccess.new({
        'AA' => :at_airport,
        'AD' => :at_delivery,
        'AF' => :at_fedex_facility,
        'AR' => :at_fedex_facility,
        'AP' => :at_pickup,
        'CA' => :canceled,
        'CH' => :location_changed,
        'DE' => :exception,
        'DL' => :delivered,
        'DP' => :departed_fedex_location,
        'DR' => :vehicle_furnished_not_used,
        'DS' => :vehicle_dispatched,
        'DY' => :exception,
        'EA' => :exception,
        'ED' => :enroute_to_delivery,
        'EO' => :enroute_to_origin_airport,
        'EP' => :enroute_to_pickup,
        'FD' => :at_fedex_destination,
        'HL' => :held_at_location,
        'IT' => :in_transit,
        'LO' => :left_origin,
        'OC' => :order_created,
        'OD' => :out_for_delivery,
        'PF' => :plane_in_flight,
        'PL' => :plane_landed,
        'PU' => :picked_up,
        'RS' => :return_to_shipper,
        'SE' => :exception,
        'SF' => :at_sort_facility,
        'SP' => :split_status,
        'TR' => :transfer
      })

      def self.service_name_for_code(service_code)
        ServiceTypes[service_code] || "FedEx #{service_code.titleize.sub(/Fedex /, '')}"
      end
      
      def requirements
        [:key, :password, :account, :login]
      end
      
      def find_rates(shipper, recipient, packages, options = {})
        options = @options.update(options)
        packages = Array(packages)
        
        rate_request = build_rate_request(shipper, recipient, packages, options)        
        response = commit(save_request(rate_request), (options[:test] || false))
        
        parse_rate_response(shipper, recipient, packages, response, options)
      end
      
      def find_tracking_info(tracking_number, options={})
        options = @options.update(options)
        
        tracking_request = build_tracking_request(tracking_number, options)
        response = commit(save_request(tracking_request), (options[:test] || false)).gsub(/<(\/)?.*?\:(.*?)>/, '<\1\2>')
        parse_tracking_response(response, options)
      end
      
      def ship(shipper, recipient, packages, account_number, options = {})
        packages = Array(packages)
        
        ship_request = build_ship_request(shipper, recipient, packages, account_number)        
        response = commit(ship_request)
        parse_ship_response(shipper, recipient, packages, response)        
      end

      protected
      
      def build_ship_request(shipper, recipient, packages, account_number)
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
                ship_request << XmlNode.new('ServiceType', 'GROUND_HOME_DELIVERY')                
                ship_request << XmlNode.new('PackagingType', 'YOUR_PACKAGING')       
                ship_request << shipper.fedex_xml
                ship_request << recipient.fedex_xml

                ship_request << XmlNode.new('ShippingChargesPayment') do |charge|
                  charge << XmlNode.new('PaymentType', 'SENDER')
                  charge << XmlNode.new('Payor') do |payor|
                    payor << XmlNode.new('ResponsibleParty') do |party|
                      party << XmlNode.new('AccountNumber', account_number)
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
      
      def build_rate_request(shipper, recipient, packages, options={})
        #imperial = ['US','LR','MM'].include?(shipper.address.country_code(:alpha2))
        imperial = true

        xml_request = XmlNode.new('soapenv:Envelope', 'xmlns:soapenv' => 'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns' => 'http://fedex.com/ws/rate/v13') do |root_node|        
          
          root_node << XmlNode.new('soapenv:Header')
          root_node << XmlNode.new('soapenv:Body') do |body|

            body << XmlNode.new('RateRequest') do |request|
              request << build_request_header
              
              # Version
              request << XmlNode.new('Version') do |version_node|
                version_node << XmlNode.new('ServiceId', 'crs')
                version_node << XmlNode.new('Major', '13')
                version_node << XmlNode.new('Intermediate', '0')
                version_node << XmlNode.new('Minor', '0')
              end
              
              # Returns delivery dates
              request << XmlNode.new('ReturnTransitAndCommit', true)
              # Returns saturday delivery shipping options when available
              request << XmlNode.new('VariableOptions', 'SATURDAY_DELIVERY')
              
              request << XmlNode.new('RequestedShipment') do |rs|
                rs << XmlNode.new('ShipTimestamp', ship_timestamp(options[:turn_around_time]))
                rs << XmlNode.new('DropoffType', options[:dropoff_type] || 'REGULAR_PICKUP')
                rs << XmlNode.new('PackagingType', options[:packaging_type] || 'YOUR_PACKAGING')
                
                rs << shipper.fedex_xml
                rs << recipient.fedex_xml
                
                rs << XmlNode.new('RateRequestTypes', 'ACCOUNT')
                rs << XmlNode.new('PackageCount', packages.size)                
                    
                packages.each do |pkg|
                  rs << XmlNode.new('RequestedPackageLineItems') do |rps|
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
      
      def build_tracking_request(tracking_number, options={})
        xml_request = XmlNode.new('TrackRequest', 'xmlns' => 'http://fedex.com/ws/track/v3') do |root_node|
          root_node << build_request_header
          
          # Version
          root_node << XmlNode.new('Version') do |version_node|
            version_node << XmlNode.new('ServiceId', 'trck')
            version_node << XmlNode.new('Major', '3')
            version_node << XmlNode.new('Intermediate', '0')
            version_node << XmlNode.new('Minor', '0')
          end
          
          root_node << XmlNode.new('PackageIdentifier') do |package_node|
            package_node << XmlNode.new('Value', tracking_number)
            package_node << XmlNode.new('Type', PackageIdentifierTypes[options['package_identifier_type'] || 'tracking_number'])
          end
          
          root_node << XmlNode.new('ShipDateRangeBegin', options['ship_date_range_begin']) if options['ship_date_range_begin']
          root_node << XmlNode.new('ShipDateRangeEnd', options['ship_date_range_end']) if options['ship_date_range_end']
          root_node << XmlNode.new('IncludeDetailedScans', 1)
        end
        xml_request.to_s
      end
      
      def build_request_header
        web_authentication_detail = XmlNode.new('WebAuthenticationDetail') do |wad|
          wad << XmlNode.new('UserCredential') do |uc|
            uc << XmlNode.new('Key', @options[:key])
            uc << XmlNode.new('Password', @options[:password])
          end
        end
        
        client_detail = XmlNode.new('ClientDetail') do |cd|
          cd << XmlNode.new('AccountNumber', @options[:account])
          cd << XmlNode.new('MeterNumber', @options[:login])
        end
        
        trasaction_detail = XmlNode.new('TransactionDetail') do |td|
          td << XmlNode.new('CustomerTransactionId', 'ActiveShipping') # TODO: Need to do something better with this..
        end
        
        [web_authentication_detail, client_detail, trasaction_detail]
      end
            
      def build_location_node(name, location)
        location_node = XmlNode.new(name) do |xml_node|
          xml_node << XmlNode.new('Address') do |address_node|
            address_node << XmlNode.new('PostalCode', location.postal_code)
            address_node << XmlNode.new("CountryCode", location.country_code(:alpha2))

            address_node << XmlNode.new("Residential", true) unless location.commercial?
          end
        end
      end
      
      def parse_ship_response(shipper, recipient, packages, response)
        rate_estimates = []
        success, message = nil

        xml = REXML::Document.new(response)

        success = response_success?(xml, 'http://fedex.com/ws/ship/v12')
        message = response_message(xml, 'http://fedex.com/ws/ship/v12')        

        shipment_label = REXML::XPath.match(xml, "//version:Label", 'version' => 'http://fedex.com/ws/ship/v12' )        
        parts = REXML::XPath.match( shipment_label, "//version:Parts", 'version' => 'http://fedex.com/ws/ship/v12' )        

        images = REXML::XPath.match( parts, "//version:Image", 'version' => 'http://fedex.com/ws/ship/v12' )        
        imagecoded = images[0].get_text
        
        image = Base64.decode64(imagecoded.to_s) if imagecoded
        full_path = Pathname.new("label.pdf")
        File.open(full_path, 'wb') do|f|
          f.write(image)
        end        
        
        details = REXML::XPath.match( parts, "//version:CompletedPackageDetails", 'version' => 'http://fedex.com/ws/ship/v12' )                
        sequence = REXML::XPath.match( parts, "//version:SequenceNumber", 'version' => 'http://fedex.com/ws/ship/v12' )                                
        ids = REXML::XPath.match( details, "//version:TrackingIds", 'version' => 'http://fedex.com/ws/ship/v12' )                  
        tracking_number = REXML::XPath.match( ids, "//version:TrackingNumber", 'version' => 'http://fedex.com/ws/ship/v12')          

        #puts "SUCCESS #{success}"
        #puts "TRACKING #{tracking_number.size}"
        #tr = tracking_number[0].get_text('TrackingNumber').to_s
        
        ShipResponse.new(success, message, Hash.from_xml(response), xml: response)        
      end
      
      
      def parse_rate_response(origin, destination, packages, response, options)
        rate_estimates = []
        success, message = nil
        
        xml = REXML::Document.new(response)
        root_node = xml.elements['RateReply']
        
        success = response_success?(xml, 'http://fedex.com/ws/rate/v13')
        message = response_message(xml, 'http://fedex.com/ws/rate/v13')
        
        replies = REXML::XPath.match( xml, "//RateReplyDetails" )        
        
        replies.each do |rated_shipment|
          service_code = rated_shipment.get_text('ServiceType').to_s
          is_saturday_delivery = rated_shipment.get_text('AppliedOptions').to_s == 'SATURDAY_DELIVERY'
          service_type = is_saturday_delivery ? "#{service_code}_SATURDAY_DELIVERY" : service_code
          
          transit_time = rated_shipment.get_text('TransitTime').to_s if service_code == "FEDEX_GROUND"
          max_transit_time = rated_shipment.get_text('MaximumTransitTime').to_s if service_code == "FEDEX_GROUND"

          delivery_timestamp = rated_shipment.get_text('DeliveryTimestamp').to_s

          delivery_range = delivery_range_from(transit_time, max_transit_time, delivery_timestamp, options)

          currency = handle_incorrect_currency_codes(rated_shipment.get_text('RatedShipmentDetails/ShipmentRateDetail/TotalNetCharge/Currency').to_s)
          rate_estimates << RateEstimate.new(origin, destination, @@name,
                              self.class.service_name_for_code(service_type),
                              :service_code => service_code,
                              :total_price => rated_shipment.get_text('RatedShipmentDetails/ShipmentRateDetail/TotalNetCharge/Amount').to_s.to_f,
                              :currency => currency,
                              :packages => packages,
                              :delivery_range => delivery_range)
        end
		
        if rate_estimates.empty?
          success = false
          message = "No shipping rates could be found for the destination address" if message.blank?
        end

        RateResponse.new(success, message, Hash.from_xml(response), :rates => rate_estimates, :xml => response, :request => last_request, :log_xml => options[:log_xml])
      end

      def delivery_range_from(transit_time, max_transit_time, delivery_timestamp, options)
        delivery_range = [delivery_timestamp, delivery_timestamp]
        
        #if there's no delivery timestamp but we do have a transit time, use it
        if delivery_timestamp.blank? && transit_time.present?
          transit_range  = parse_transit_times([transit_time,max_transit_time.presence || transit_time])
          delivery_range = transit_range.map{|days| business_days_from(ship_date(options[:turn_around_time]), days)}
        end

        delivery_range
      end

      def business_days_from(date, days)
        future_date = date
        count       = 0

        while count < days
          future_date += 1.day
          count += 1 if business_day?(future_date)
        end

        future_date
      end

      def business_day?(date)
        (1..5).include?(date.wday)
      end

      def parse_tracking_response(response, options)
        xml = REXML::Document.new(response)
        root_node = xml.elements['TrackReply']
        
        success = response_success?(xml)
        message = response_message(xml)
        
        if success
          tracking_number, origin, destination, status, status_code, status_description, delivery_signature = nil
          shipment_events = []

          tracking_details = root_node.elements['TrackDetails']
          tracking_number = tracking_details.get_text('TrackingNumber').to_s

          status_code = tracking_details.get_text('StatusCode').to_s
          status_description = tracking_details.get_text('StatusDescription').to_s
          status = TRACKING_STATUS_CODES[status_code]

          if status_code == 'DL' && tracking_details.get_text('SignatureProofOfDeliveryAvailable').to_s == 'true'
            delivery_signature = tracking_details.get_text('DeliverySignatureName').to_s
          end

          origin_node = tracking_details.elements['OriginLocationAddress']

          if origin_node
            origin = Location.new(
                  :country =>     origin_node.get_text('CountryCode').to_s,
                  :province =>    origin_node.get_text('StateOrProvinceCode').to_s,
                  :city =>        origin_node.get_text('City').to_s
            )
          end

          destination = extract_destination(tracking_details)
          
          tracking_details.elements.each('Events') do |event|
            address  = event.elements['Address']

            city     = address.get_text('City').to_s
            state    = address.get_text('StateOrProvinceCode').to_s
            zip_code = address.get_text('PostalCode').to_s
            country  = address.get_text('CountryCode').to_s
            next if country.blank?
            
            location = Location.new(:city => city, :state => state, :postal_code => zip_code, :country => country)
            description = event.get_text('EventDescription').to_s

            time          = Time.parse("#{event.get_text('Timestamp').to_s}")
            zoneless_time = time.utc

            shipment_events << ShipmentEvent.new(description, zoneless_time, location)
          end
          shipment_events = shipment_events.sort_by(&:time)

        end
        
        TrackingResponse.new(success, message, Hash.from_xml(response),
          :carrier => @@name,
          :xml => response,
          :request => last_request,
          :status => status,
          :status_code => status_code,
          :status_description => status_description,
          :delivery_signature => delivery_signature,
          :shipment_events => shipment_events,
          :origin => origin,
          :destination => destination,
          :tracking_number => tracking_number
        )
      end

      def ship_timestamp(delay_in_hours)
        delay_in_hours ||= 0
        Time.now + delay_in_hours.hours
      end

      def ship_date(delay_in_hours)
        delay_in_hours ||= 0
        (Time.now + delay_in_hours.hours).to_date
      end

      def response_status_node(document, namespace = "")
        REXML::XPath.match( document, "//version:Notifications", 'version' => namespace )        
      end
      
      def response_success?(document, namespace = "")
        #formatter = REXML::Formatters::Pretty.new(2)
        #formatter.compact = true # This is the magic line that does what you need!
        #formatter.write(document, $stdout)
        
        names = response_status_node(document, namespace)        
        
        highest = REXML::XPath.match( document, "//version:HighestSeverity", 'version' => namespace )        
        
        h = []
        if highest && highest.size > 0
          h << highest[0].get_text.to_s
        end
        
        intersect = %w{SUCCESS WARNING NOTE} & h
        if intersect.length > 0
          return true
        else
          return false
        end
      end
      
      def response_message(document, namespace)
        back = []
        response_node = response_status_node(document, namespace)
        response_node.each do |node|
          back << "#{node.get_text('Severity')} - #{node.get_text('Code')}: #{node.get_text('LocalizedMessage')}"  
        end
        back
      end
      
      def commit(request, test = true)
        res = ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))        
        res
      end
      
      def handle_incorrect_currency_codes(currency)
        case currency
        when /UKL/i then 'GBP'
        when /SID/i then 'SGD'
        else currency
        end
      end

      def parse_transit_times(times)
        results = []
        times.each do |day_count|
          days = TransitTimes.index(day_count.to_s.chomp)
          results << days.to_i
        end
        results
      end

      def extract_destination(document)
        node = document.elements['DestinationAddress'] || document.elements['ActualDeliveryAddress']

        args = if node
          {
            :country => node.get_text('CountryCode').to_s,
            :province => node.get_text('StateOrProvinceCode').to_s,
            :city => node.get_text('City').to_s
          }
        else
          {
            :country => ActiveMerchant::Country.new(:alpha2 => 'ZZ', :name => 'Unknown or Invalid Territory', :alpha3 => 'ZZZ', :numeric => '999'),
            :province => 'unknown',
            :city => 'unknown'
          }
        end

        Location.new(args)
      end
    end
  end
end
