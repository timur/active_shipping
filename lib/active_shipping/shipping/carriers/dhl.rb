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
        [:login, :password, :account_number, :test]
      end

      def finde_quotes(options = {})
        response = commit(save_request(request), (options[:test] || false))

        if Rails && Rails.logger
          Rails.logger.debug { "Find Rates request DHL: #{last_request}" }
          Rails.logger.debug { "Find Rates response DHL: #{response}" }          
        end
        
        parse_rate_response(shipper, recipient, packages, request, response, options)
      end

      def response_success?(document)
        if response_status_node(document)
          %w{Success}.include? response_status_node(document).get_text('ActionNote').to_s
        else
          false
        end
      end

      def response_message(document)
        res = Hash.from_xml(document)
        res = res["ShipmentValidateErrorResponse"]
        "#{res['Response']['Status']['Condition']['ConditionCode']} - #{res['Response']['Status']['Condition']['ConditionData']}"
      end

      def response_status_node(document)
        document.elements['/*/Note/']
      end

      protected


      def commit(request, test = false)
        ssl_post(test ? TEST_URL : LIVE_URL, request.gsub("\n",''))
      end
    end
  end
end