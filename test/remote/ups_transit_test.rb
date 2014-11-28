# encoding: utf-8
require_relative '../test_helper'

class UpsTransitTest < Test::Unit::TestCase

  def setup
  end
      
  def test_transit_raw    
    ups = UPS.new(test: false)
    response = ups.transit(raw_xml: "testcases/transit_raw.xml", test: false)    
    
    save_xml(response, "test_transit_raw_ups")
    assert_not_nil response
  end    
  
  def test_transit_mexico
    transit_request = ActiveMerchant::Shipping::UpsTransitRequest.new(
      postcode_from: "11510",
      postcode_to: "11510",      
      country_from: "MX",
      country_to: "MX",
      weight: 2.0,
      pickup_date: "20141128"            
    )
    
    ups = UPS.new(access_license_number: '0CCCCED94B9FB025', password: 'Holaups2014', user_id: 'sven.crone', test: false)
    response = ups.transit(request: transit_request, test: false)    
    
    save_xml(response, "test_transit_mexico")
    
    assert response.success == true
    
    puts "#{ap response.summaries}"

    assert_not_nil response
  end  
end

#<TimeInTransitResponse>
#    <Response>
#        <TransactionReference>
#            <CustomerContext>Your Test Case Summary Description</CustomerContext>
#            <XpciVersion>1.001</XpciVersion>
#        </TransactionReference>
#        <ResponseStatusCode>1</ResponseStatusCode>
#        <ResponseStatusDescription>Success</ResponseStatusDescription>
#    </Response>
#    <TransitResponse>
#        <PickupDate>2014-11-27</PickupDate>
#        <TransitFrom>
#            <AddressArtifactFormat>
#                <PoliticalDivision2>MEXICO CITY</PoliticalDivision2>
#                <PoliticalDivision1>DISTRITO FEDERAL</PoliticalDivision1>
#                <Country>MEXICO</Country>
#                <CountryCode>MX</CountryCode>
#                <PostcodePrimaryLow>11550</PostcodePrimaryLow>
#            </AddressArtifactFormat>
#        </TransitFrom>
#        <TransitTo>
#            <AddressArtifactFormat>
#                <PoliticalDivision2>MEXICO CITY</PoliticalDivision2>
#                <PoliticalDivision1>DISTRITO FEDERAL</PoliticalDivision1>
#                <Country>MEXICO</Country>
#                <CountryCode>MX</CountryCode>
#                <PostcodePrimaryLow>11550</PostcodePrimaryLow>
#            </AddressArtifactFormat>
#        </TransitTo>
#        <AutoDutyCode>02</AutoDutyCode>
#        <ShipmentWeight>
#            <UnitOfMeasurement>
#                <Code>KGS</Code>
#            </UnitOfMeasurement>
#            <Weight>2.0</Weight>
#        </ShipmentWeight>
#        <InvoiceLineTotal>
#            <CurrencyCode>USD</CurrencyCode>
#            <MonetaryValue>1.00</MonetaryValue>
#        </InvoiceLineTotal>
#        <Disclaimer>Services listed as guaranteed are backed by a money-back guarantee for transportation charges only. See Terms and Conditions in the Service Guide for details. Certain commodities and high value shipments may require additional transit time for customs clearance.</Disclaimer>
#        <ServiceSummary>
#            <Service>
#                <Code>26</Code>
#                <Description>UPS Express Saver</Description>
#            </Service>
#            <Guaranteed>
#                <Code>Y</Code>
#            </Guaranteed>
#            <EstimatedArrival>
#                <BusinessTransitDays>1</BusinessTransitDays>
#                <Time>23:30:00</Time>
#                <PickupDate>2014-11-27</PickupDate>
#                <PickupTime>19:00:00</PickupTime>
#                <HolidayCount>0</HolidayCount>
#                <DelayCount>0</DelayCount>
#                <Date>2014-11-28</Date>
#                <DayOfWeek>FRI</DayOfWeek>
#                <TotalTransitDays>1</TotalTransitDays>
#                <CustomerCenterCutoff>17:00:00</CustomerCenterCutoff>
#                <RestDays>0</RestDays>
#            </EstimatedArrival>
#        </ServiceSummary>
#        <ServiceSummary>
#            <Service>
#                <Code>26</Code>
#                <Description>UPS Express Saver</Description>
#            </Service>
#            <Guaranteed>
#                <Code>Y</Code>
#            </Guaranteed>
#            <EstimatedArrival>
#                <BusinessTransitDays>2</BusinessTransitDays>
#                <Time>23:30:00</Time>
#                <PickupDate>2014-11-27</PickupDate>
#                <PickupTime>20:00:00</PickupTime>
#                <HolidayCount>0</HolidayCount>
#                <DelayCount>0</DelayCount>
#                <Date>2014-12-01</Date>
#                <DayOfWeek>MON</DayOfWeek>
#                <TotalTransitDays>4</TotalTransitDays>
#                <CustomerCenterCutoff>19:00:00</CustomerCenterCutoff>
#                <RestDays>2</RestDays>
#            </EstimatedArrival>
#        </ServiceSummary>
#        <MaximumListSize>5</MaximumListSize>
#    </TransitResponse>
#</TimeInTransitResponse>