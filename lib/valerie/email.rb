require_relative 'ordered'

module Valerie
  class Email
    include Ordered
    
    def self.from_s(data)
      data = data[data.index("EMAIL;")..] unless data.start_with?("EMAIL;")
      identifier = data.split(":").last.split(";")
      options = data.gsub("EMAIL", "").split(":").first.split(";").compact.filter { _1.to_s.include?('=')}.map { _1.downcase.split("=") }.to_h
      
      new(
        address: identifier[0],
        **options
      )
    end
    
    attr_reader :address, :options
    
    def initialize(address:, **options)
      @address = address
      @options = options
      
      raise ArgumentError, 'Invalid Position' if invalid_position?
    end
    
    def [](key)
      @options[key]
    end
    
    def to_s
      parts = ['EMAIL']
      
      parts << "PERF=#{@options[:position]}" if position?
      parts << type_to_s if type?
      
      parts.join(';') + ":#{@address}"
    end
    
    def to_h
      {
        address: @address,
        position: @options[:position],
        type: @options[:type],
      }
    end
    
    private
      def type?
        @options[:type]
      end
    
      def type_to_s
        if @options[:type].is_a?(Array)
          "TYPE=\"#{@options[:type].join(',')}\""
        else
          "TYPE=#{@options[:type]}"
        end
      end
  end
end
