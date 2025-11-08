require_relative 'ordered'

module Valerie
  # Represents a physical address in a VCard
  #
  # @example Full address
  #   address = Valerie::Address.new(
  #     post_office_box: 'PO Box 123',
  #     extended_address: 'Suite 200',
  #     street_address: '123 Main St',
  #     locality: 'New York',
  #     region: 'NY',
  #     postal_code: '10001',
  #     country: 'USA'
  #   )
  #
  # @example Simple address
  #   address = Valerie::Address.new(
  #     post_office_box: '',
  #     extended_address: '',
  #     street_address: '123 Main St',
  #     locality: 'New York',
  #     region: 'NY',
  #     postal_code: '10001',
  #     country: 'USA'
  #   )
  class Address
    include Ordered

    # Parse an address from VCard ADR field string
    #
    # @param data [String] ADR field string
    # @return [Address] Parsed address object
    # @api private
    def self.from_s(data)
      data = data[data.index("ADR;")..] unless data.start_with?("ADR;")
      identifier = data.split(":").last.split(";")
      options = data.gsub("ADR", "").split(":").first.split(";").compact.filter { _1.to_s.include?('=')}.map { _1.downcase.split("=") }.to_h

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

    # Create a new address
    #
    # @param post_office_box [String] Post office box
    # @param extended_address [String] Extended address (e.g., apartment, suite)
    # @param street_address [String] Street address
    # @param locality [String] City or locality
    # @param region [String] State, province, or region
    # @param postal_code [String] ZIP or postal code
    # @param country [String] Country
    # @param options [Hash] Additional options
    # @option options [Integer] :position Position in collection (1-based, used internally)
    # @raise [ArgumentError] if position is invalid (< 1)
    # @return [Address]
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

      parts << "PREF=#{position}" if position?

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
