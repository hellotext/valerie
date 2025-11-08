require_relative 'ordered'

module Valerie
  # Represents a phone number in a VCard
  #
  # @example Simple phone number
  #   phone = Valerie::Phone.new('+1-555-1234')
  #
  # @example Phone with type
  #   phone = Valerie::Phone.new('+1-555-1234', type: :work)
  #
  # @example Phone with multiple types
  #   phone = Valerie::Phone.new('+1-555-1234', type: [:work, :voice])
  #
  # @example Phone with position
  #   phone = Valerie::Phone.new('+1-555-1234', type: :cell, position: 1)
  class Phone
    # Valid phone type values according to VCard spec
    # @note This constant is currently not enforced
    VALID_TYPES = %w[text voice fax cell video pager textphone].freeze

    include Ordered

    # Parse a phone number from VCard TEL field string
    #
    # @param data [String] TEL field string (e.g., "TEL;TYPE=work:+1-555-1234")
    # @return [Phone] Parsed phone object
    # @api private
    def self.from_s(data)
      data = data[data.index("TEL;")..] unless data.start_with?("TEL;")
      identifier = data.split(":").last
      options = data.gsub("TEL", "").split(":").first.split(";").compact.filter { _1.to_s.include?('=')}.map { _1.downcase.split("=") }.to_h

      new(identifier, **options)
    end

    # @return [String] The phone number
    # @return [Hash] Additional options (type, position, etc.)
    attr_reader :number, :options

    # Create a new phone number
    #
    # @param number [String] The phone number
    # @param options [Hash] Additional options
    # @option options [String, Symbol, Array] :type Type(s) like :work, :home, :cell, :voice, :fax
    # @option options [Integer] :position Position in collection (1-based, used internally)
    # @raise [ArgumentError] if position is invalid (< 1)
    # @return [Phone]
    # @example
    #   phone = Valerie::Phone.new('+1-555-1234', type: :work)
    def initialize(number, **options)
      @number = number
      @options = options.transform_keys!(&:to_sym)
      @type = @options[:type] || 'voice'

      raise ArgumentError, 'Invalid Position' if invalid_position?
    end

    # Access phone options
    #
    # @param key [Symbol] Option key
    # @return [Object, nil] Option value
    def [](key)
      @options[key]
    end

    # Convert to VCard TEL field string
    #
    # @return [String] TEL field in VCard format
    # @example
    #   phone.to_s #=> "TEL;PREF=1;TYPE=work:+1-555-1234"
    def to_s
      parts = ['TEL']

      parts << "PREF=#{@options[:position]}" if position?
      parts << type_to_s if type?

      parts.join(';') + ":#{@number}"
    end

    # Convert to hash representation
    #
    # @return [Hash] Hash with :number, :type, and :position keys
    def to_h
      {
        number: @number,
        type: @type,
        position: @options[:position],
      }
    end

    private
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
