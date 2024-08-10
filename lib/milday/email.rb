module Milday
  class Email
    def self.from_s(data)
      data = data[data.index("EMAIL;")..] unless data.starts_with?("EMAIL;")
      identifier = data.split(":").last.split(";")
      options = data.gsub("EMAIL", "").split(":").first.split(";").compact_blank.map { _1.split("=") }.to_h
      
      new(
        address: identifier[0],
        **options
      )
    end
    
    def initialize(address:, **options)
      @address = address
      @options = options
    end
    
    def [](key)
      @options[key]
    end
    
    def to_s
      parts = ['EMAIL']
      
      parts << 'PERF=1' if preferred?
      parts << type_to_s if type?
      
      parts.join(';') + ":#{@address}"
    end
    
    def to_h
      {
        address: @address,
        preferred: @options[:preferred],
        type: @options[:type],
      }
    end
    
    private
      def preferred?
        @options[:preferred]
      end
      
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
