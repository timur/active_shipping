module ActiveMerchant
  module Shipping
    class Carrier
      
      include RequiresParameters
      include PostsData
      include Quantified
      
      attr_reader :last_request, :last_response
      attr_accessor :test_mode
      alias_method :test_mode?, :test_mode
      
      # Credentials should be in options hash under keys :login, :password and/or :key.
      def initialize(options = {})
        requirements.each {|key| requires!(options, key)}
        @options = options
        @last_request = nil
        @last_response = nil        
        @test_mode = @options[:test]
      end

      # Override to return required keys in options hash for initialize method.
      def requirements
        []
      end
                  
      protected
      
      def node_text_or_nil(xml_node)
        xml_node ? xml_node.text : nil
      end
            
      # Use after building the request to save for later inspection. Probably won't ever be overridden.
      def save_request(request)
        @last_request = request
      end

    end
  end
end
