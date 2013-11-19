#!/usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler'
Bundler.setup

require 'test/unit'
require 'active_shipping'
require 'mocha/setup'
require 'timecop'
require 'awesome_print'
require 'date'

XmlNode # trigger autorequire

module Test
  module Unit
    class TestCase
      include ActiveMerchant::Shipping
      
      LOCAL_CREDENTIALS = ENV['HOME'] + '/.active_merchant/fixtures.yml' unless defined?(LOCAL_CREDENTIALS)
      DEFAULT_CREDENTIALS = File.dirname(__FILE__) + '/fixtures.yml' unless defined?(DEFAULT_CREDENTIALS)
      
      MODEL_FIXTURES = File.dirname(__FILE__) + '/fixtures/' unless defined?(MODEL_FIXTURES)

      def all_fixtures
        @@fixtures ||= load_fixtures
      end
      
      def date_of_next(day)
        date  = Date.parse(day)
        delta = date > Date.today ? 0 : 7
        date + delta
      end
      
      def save_xml(response, name)
        req = nil
        formatted_request = ""
        formatter = REXML::Formatters::Pretty.new
        formatted_response, formatted_request = "", ""
        formatter.compact = true

        #puts "RESPONSE #{response.response}"
        resp = REXML::Document.new response.response
        
        begin
          req = REXML::Document.new response.request              
          formatter.write(req, formatted_request)
        rescue Exception => e
          formatted_request = response.request
        end
        
        formatter.write(resp, formatted_response)        
        t = Time.now
        dir_name = "test/last_requests/" + name
        
        unless File.directory?(dir_name)
          Dir.mkdir(File.join(Dir.pwd, dir_name), 0700)
        end

        File.open(dir_name + "/#{name}_request_#{Time.now.to_f}.xml", 'w') {|f| f.write(formatted_request) }
        File.open(dir_name + "/#{name}_response_#{Time.now.to_f}.xml", 'w') {|f| f.write(formatted_response) }    
      end
            
      
      def symbolize_keys(hash)
        return unless hash.is_a?(Hash)
        
        hash.symbolize_keys!
        hash.each{|k,v| symbolize_keys(v)}
      end

      def file_fixture(filename)
        File.open("test/fixtures/files/#{filename}", "rb") { |f| f.read }
      end
    end
  end
end