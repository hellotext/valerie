require_relative 'ordered'

module Valerie
  # Represents an email address in a VCard
  #
  # @example Simple email
  #   email = Valerie::Email.new(address: 'user@example.com')
  #
  # @example Email with type
  #   email = Valerie::Email.new(address: 'work@example.com', type: :work)
  #
  # @example Email with multiple types
  #   email = Valerie::Email.new(address: 'user@example.com', type: [:work, :internet])
  class Email
    include Ordered

    # Parse an email from VCard EMAIL field string
    #
    # @param data [String] EMAIL field string (e.g., "EMAIL;TYPE=work:user@example.com")
    # @return [Email] Parsed email object
    # @api private
    def self.from_s(data)
      data = data[data.index("EMAIL;")..] unless data.start_with?("EMAIL;")
      identifier = data.split(":").last.split(";")
      options = data.gsub("EMAIL", "").split(":").first.split(";").compact.filter { _1.to_s.include?('=')}.map { _1.downcase.split("=") }.to_h

      new(
        address: identifier[0],
        **options
      )
    end

    # @return [String] The email address
    # @return [Hash] Additional options (type, position, etc.)
    attr_reader :address, :options

    # Create a new email address
    #
    # @param address [String] The email address
    # @param options [Hash] Additional options
    # @option options [String, Symbol, Array] :type Type(s) like :work, :home, :internet
    # @option options [Integer] :position Position in collection (1-based, used internally)
    # @raise [ArgumentError] if position is invalid (< 1)
    # @return [Email]
    # @example
    #   email = Valerie::Email.new(address: 'user@example.com', type: :work)
    def initialize(address:, **options)
      @address = address
      @options = options

      raise ArgumentError, 'Invalid Position' if invalid_position?
    end

    def [](key)
      @options[key]
    end

    def to_s
      parts = ['EMAIL']

      parts << "PREF=#{@options[:position]}" if position?
      parts << type_to_s if type?

      parts.join(';') + ":#{@address}"
    end

    def to_h
      {
        address: @address,
        position: @options[:position],
        type: @options[:type],
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
