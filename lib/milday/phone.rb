module Milday
  class Phone
    def self.from_s(data)
      data = data[data.index("TEL;")..] unless data.starts_with?("TEL;")
      identifier = data.split(":").last
      options = data.gsub("TEL", "").split(":").first.split(";").compact_blank.map { _1.split("=") }.to_h
      
      new(identifier, **options)
    end
    
    def initialize(tel, **options)
      @tel = tel
      @options = options
    end
    
    def [](key)
      @options[key]
    end
    
    def to_s
      "TEL;#{@options.reject { |key, _| %i[type].exclude?(key)} .map { "#{_1}=#{_2}" }.join(";")}:#{@tel}"
    end
    
    def to_h
      {
        number: @tel,
        type: @options[:type],
        preferred: @options[:preferred],
      }
    end
  end
end
