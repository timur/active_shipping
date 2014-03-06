# -*- encoding: utf-8 -*-
module ActiveMerchant
  module Shipping
    module UpsConstants
      
      RESOURCES = {
        :rates => 'ups.app/xml/Rate',
        :track => 'ups.app/xml/Track',
        :ship_confirm => 'ups.app/xml/ShipConfirm',        
        :ship_accept => 'ups.app/xml/ShipAccept'                
      }
      
      DAILY_PICKUP = "01"
      ONE_TIME_PICKUP = "06"      
      
      # 00 = UNKNOWN;
      # 01 = UPS Letter;
      # 02 = Package;
      # 03 = Tube;
      # 04 = Pak;
      # 21 = Express Box;
      # 24 = 25KG Box;
      # 25 = 10KG Box;
      # 30 = Pallet;
      # 2a = Small Express Box; 2b = Medium Express Box; 2c = Large Express Box
      PACKAGE = "02"
      DOCUMENT = "01"
      
      CLASSIFICATION_DAILY_RATES = "01"
      CLASSIFICATION_ACCOUNT_RATES = "00"
            
      # CustomerClassification Valid values are:
      # 00- Rates Associated with Shipper Number;
      # 01- Daily Rates;
      # 04- Retail Rates;
      # 53- Standard List Rates;
      # The default value is
      # 01 (Daily Rates) when the Pickup Type code is 01 (Daily pickup).
      # The default value is
      # 04 (Retail Rates) when the Pickup Type code is:
      # 06 -One Time Pickup,
      # 07 - On Call Air,
      # 19 - Letter Center, or
      # 20 - Air Service Center      

      PICKUP_CODES = HashWithIndifferentAccess.new({
        :daily_pickup => "01",
        :customer_counter => "03",
        :one_time_pickup => "06",
        :on_call_air => "07",
        :suggested_retail_rates => "11",
        :letter_center => "19",
        :air_service_center => "20"
      })

      CUSTOMER_CLASSIFICATIONS = HashWithIndifferentAccess.new({
        :wholesale => "01",
        :occasional => "03",
        :retail => "04"
      })

      # these are the defaults described in the UPS API docs,
      # but they don't seem to apply them under all circumstances,
      # so we need to take matters into our own hands
      DEFAULT_CUSTOMER_CLASSIFICATIONS = Hash.new do |hash,key|
        hash[key] = case key.to_sym
        when :daily_pickup then :wholesale
        when :customer_counter then :retail
        else
          :occasional
        end
      end

      DEFAULT_SERVICES = {
        "01" => "UPS Next Day Air",
        "02" => "UPS Second Day Air",
        "03" => "UPS Ground",
        "07" => "UPS Worldwide Express",
        "08" => "UPS Worldwide Expedited",
        "11" => "UPS Standard",
        "12" => "UPS Three-Day Select",
        "13" => "UPS Next Day Air Saver",
        "14" => "UPS Next Day Air Early A.M.",
        "54" => "UPS Worldwide Express Plus",
        "59" => "UPS Second Day Air A.M.",
        "65" => "UPS Saver",
        "82" => "UPS Today Standard",
        "83" => "UPS Today Dedicated Courier",
        "84" => "UPS Today Intercity",
        "85" => "UPS Today Express",
        "86" => "UPS Today Express Saver"
      }

      CANADA_ORIGIN_SERVICES = {
        "01" => "UPS Express",
        "02" => "UPS Expedited",
        "14" => "UPS Express Early A.M."
      }

      MEXICO_ORIGIN_SERVICES = {
        "07" => "UPS Express",
        "08" => "UPS Expedited",
        "54" => "UPS Express Plus"
      }

      EU_ORIGIN_SERVICES = {
        "07" => "UPS Express",
        "08" => "UPS Expedited"
      }

      OTHER_NON_US_ORIGIN_SERVICES = {
        "07" => "UPS Express"
      }

      TRACKING_STATUS_CODES = HashWithIndifferentAccess.new({
        'I' => :in_transit,
        'D' => :delivered,
        'X' => :exception,
        'P' => :pickup,
        'M' => :manifest_pickup
      })

      # From http://en.wikipedia.org/w/index.php?title=European_Union&oldid=174718707 (Current as of November 30, 2007)
      EU_COUNTRY_CODES = ["GB", "AT", "BE", "BG", "CY", "CZ", "DK", "EE", "FI", "FR", "DE", "GR", "HU", "IE", "IT", "LV", "LT", "LU", "MT", "NL", "PL", "PT", "RO", "SK", "SI", "ES", "SE"]

      US_TERRITORIES_TREATED_AS_COUNTRIES = ["AS", "FM", "GU", "MH", "MP", "PW", "PR", "VI"]

    end
  end
end