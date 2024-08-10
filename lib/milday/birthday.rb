module Milday
  class Birthday
    def self.from_s(data)
      new data.gsub("BDAY:", "")
    end
    
    def initialize(date)
      if date.respond_to?(:strftime)
        @date = date.strftime("%Y-%m-%d")
      else
        @date = date
      end
    end
    
    def to_s
      "BDAY:#{@date}"
    end
    
    def to_h
      { date: }
    end
  end
end
