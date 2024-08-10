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
      "EMAIL;#{@options.map { "#{_1}=#{_2}" }.join(";")}:#{@address}"
    end
    
    def to_h
      {
        address: @address
      }
    end
  end
end
