require 'date'

module Valerie
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
    
    def to_date
      Date.new(year, month, day)
    end
    
    def to_h
      {
        day:,
        month:,
        year:
      }
    end
    
    private
      def year
        @year ||= @date.split('-')[0].to_i
      end
    
      def month
        @month ||=  @date.split('-')[1].to_i
      end
    
      def day
        @day ||=  @date.split('-')[-1].to_i
      end
  end
end
