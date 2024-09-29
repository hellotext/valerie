module Valerie
  class Gender
    SEX_COMPONENTS = {
      male: 'M',
      female: 'F',
      other: 'O',
      unknown: 'U',
      none: 'N'
    }
    
    attr_reader :identifier
    
    def self.from_s(data)
      new(data.split(":").last)
    end
    
    def initialize(identifier)
      if SEX_COMPONENTS.keys.include?(identifier.to_s.downcase.to_sym)
        @identifier = SEX_COMPONENTS[identifier.to_s.downcase.to_sym]
      else
        @identifier = identifier
      end
      
      raise ArgumentError, 'Invalid Sex identifier' unless SEX_COMPONENTS.values.include?(@identifier)
    end
    
    def to_s
      "GENDER:#{@identifier}"
    end
    
    def to_h
      {
        identifier: @identifier,
        sex:,
      }
    end
    
    def sex
      @sex ||= SEX_COMPONENTS.key(@identifier)
    end
  end
end
