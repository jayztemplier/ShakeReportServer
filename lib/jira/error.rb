module Jira
  class Error
    
    class NotConnectedError < StandardError
    end

    class NoSuchProjectError < StandardError
    end

    class RequiredFieldsError < StandardError
      attr_reader :fields

      def initialize(fields) 
        @fields = fields
      end
    end
    
    def self.build_error(body)
      error = StandardError.new("Jira ticket creation failed with error #{body}")
      json = JSON.parse body
      fields = json['errors'].select{ |field, error| error =~ / is required.$/ }.keys
      error = RequiredFieldsError.new(fields) if fields.length > 0
    ensure
      return error
    end
  end
end