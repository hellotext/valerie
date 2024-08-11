require_relative 'ordered'

module Milday
  class Address
    include Ordered
    
    def self.from_s(data)
      data = data[data.index("ADR;")..] unless data.starts_with?("ADR;")
      identifier = data.split(":").last.split(";")
      options = data.gsub("ADR", "").split(":").first.split(";").compact_blank.map { _1.split("=") }.to_h

      new(
        post_office_box: identifier[0],
        extended_address: identifier[1],
        street_address: identifier[2],
        locality: identifier[3],
        region: identifier[4],
        postal_code: identifier[5],
        country: identifier[6],
        **options
      )
    end

    def initialize(post_office_box:, extended_address:, street_address:, locality:, region:, postal_code:, country:, **options)
      @post_office_box = post_office_box
      @extended_address = extended_address
      @street_address = street_address
      @locality = locality
      @region = region
      @postal_code = postal_code
      @country = country
      @options = options
      
      raise ArgumentError, 'Invalid Position' if invalid_position?
    end

    def [](key)
      @options[key]
    end

    def to_s
      parts = ['ADR']
      
      parts << "PERF=#{position}" if position?
      
      @options.map do |key, value|
        next if key == :position
        parts << "#{key}=#{value}"
      end
      
      parts.join(';') + ":#{identifier}"
    end

    def identifier
      [@post_office_box, @extended_address, @street_address, @locality, @region, @postal_code, @country].join(';')
    end

    def to_h
      {
        post_office_box: @post_office_box,
        extended_address: @extended_address,
        street_address: @street_address,
        locality: @locality,
        region: @region,
        postal_code: @postal_code,
        country: @country
      }
    end
  end
end
