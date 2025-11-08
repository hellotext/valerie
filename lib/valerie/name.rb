module Valerie
  # Represents a person's name in a VCard
  #
  # @example With hash
  #   name = Valerie::Name.new(first_name: 'John', last_name: 'Doe')
  #
  # @example With full details
  #   name = Valerie::Name.new(
  #     first_name: 'John',
  #     last_name: 'Doe',
  #     middle_name: 'Michael',
  #     prefix: 'Dr.',
  #     suffix: 'Jr.'
  #   )
  #
  # @example With string (splits on first space)
  #   name = Valerie::Name.new('John Doe')
  class Name
    class << self
      # Create a new Name from various input formats
      #
      # @param parts [Hash, String] Name data
      # @return [Name]
      def new(parts)
        if parts.is_a?(Hash)
          super **parts
        else
          first_name, last_name = parts.split(" ")

          super first_name:, last_name:
        end
      end

      # Parse a name from VCard N field string
      #
      # @param data [String] N field string
      # @return [Name] Parsed name object
      # @api private
      def from_s(data)
        parts = data.gsub("N:", "").split(";")
        new first_name: parts[1], last_name: parts[0], middle_name: parts[2], prefix: parts[3], suffix: parts[4]
      end
    end

    # @return [String, nil] Given name (first name)
    # @return [String, nil] Family name (last name)
    attr_reader :first_name, :last_name

    # Create a new name
    #
    # @param first_name [String, nil] Given name
    # @param last_name [String, nil] Family name
    # @param middle_name [String, nil] Middle name
    # @param prefix [String, nil] Name prefix (e.g., "Dr.", "Ms.")
    # @param suffix [String, nil] Name suffix (e.g., "Jr.", "PhD")
    def initialize(first_name: nil, last_name: nil, middle_name: nil, prefix: nil, suffix: nil)
      @first_name = first_name
      @last_name = last_name
      @middle_name = middle_name
      @prefix = prefix
      @suffix = suffix
    end

    def to_s
      "N:#{[@last_name, @first_name, @middle_name, @prefix, @suffix].join(";")}"
    end

    def to_h
      {
        first_name: @first_name,
        last_name: @last_name,
        middle_name: @middle_name,
        prefix: @prefix,
        suffix: @suffix,
      }
    end
  end
end
