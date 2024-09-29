require_relative 'ordered'

module Valerie
  class Phone
    VALID_TYPES = %w[text voice fax cell video pager textphone].freeze
    
    include Ordered
    
    def self.from_s(data)
      data = data[data.index("TEL;")..] unless data.start_with?("TEL;")
      identifier = data.split(":").last
      options = data.gsub("TEL", "").split(":").first.split(";").compact.filter { _1.to_s.include?('=')}.map { _1.downcase.split("=") }.to_h
      
      new(identifier, **options)
    end
    
    attr_reader :number, :options
    
    def initialize(number, **options)
      @number = number
      @options = options.transform_keys!(&:to_sym)
      @type = @options[:type] || 'voice'
      
      raise ArgumentError, 'Invalid Position' if invalid_position?
    end
    
    def [](key)
      @options[key]
    end
    
    def to_s
      parts = ['TEL']
      
      parts << "PERF=#{@options[:position]}" if position?
      parts << type_to_s if type?
      
      parts.join(';') + ":#{@number}"
    end
    
    def to_h
      {
        number: @tel,
        type: @type,
        position: @options[:position],
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
