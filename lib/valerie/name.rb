module Valerie
  class Name
    class << self
      def new(parts)
        if parts.is_a?(Hash)
          super **parts
        else
          first_name, last_name = parts.split(" ")
          
          super first_name:, last_name:
        end
      end
      
      def from_s(data)
        parts = data.gsub("N:", "").split(";")
        new first_name: parts[1], last_name: parts[0], middle_name: parts[2], prefix: parts[3], suffix: parts[4]
      end
    end
    
    attr_reader :first_name, :last_name
    
    def initialize(first_name: nil, last_name: nil, middle_name: nil, prefix: nil, suffix: nil)
      @first_name = first_name
      @last_name = last_name
      @middle_name = middle_name
      @prefix = prefix
      @suffix = suffix
    end
    
    def to_s
      "N:#{[@last_name, @first_name, @middle_name, @prefix, @suffix].join(";")}"
    end
    
    def to_h
      {
        first_name: @first_name,
        last_name: @last_name,
        middle_name: @middle_name,
        prefix: @prefix,
        suffix: @suffix,
      }
    end
  end
end
