# -*- encoding: utf-8 -*-
module ActiveMerchant
  module Shipping
    module DhlConstants
      
        PACKAGE = "package"
        DOCUMENT = "document"
        
        DisabledProducts = ["C", "G", "U"]

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
                
        DoorTo = {
          'DD' => "Door to Door",
          'DA' => "Door to Airport",
          'AA' => 'Door to Dor non-compliant',
          'AA' => 'Door to Dor non-compliant'
        }      
        
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
              
    end
  end
end