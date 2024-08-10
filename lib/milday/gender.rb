module Milday
  class Gender
    attr_reader :identifier
    
    def self.from_s(data)
      new(data.split(":").last)
    end
    
    def initialize(identifier)
      @identifier = identifier
    end
    
    def to_s
      "GENDER:#{@identifier}"
    end
    
    def to_h
      {
        identifier: @identifier
      }
    end
  end
end
