require_relative '../valerie'
require_relative 'core/parser'

module Valerie
  # Represents a VCard (Contact Card) that can be generated or parsed.
  #
  # A Card contains various contact properties like name, email addresses,
  # phone numbers, addresses, and more. It can be converted to VCard 3.0 format
  # or parsed from VCard strings.
  #
  # @example Creating a new card
  #   card = Valerie::Card.new
  #   card.name = { first_name: 'Jane', last_name: 'Smith' }
  #   card.organization = { name: 'Acme Corp', department: 'Engineering' }
  #   card.birthday = Date.new(1990, 5, 15)
  #   card.gender = 'female'
  #
  # @example Adding contacts
  #   card.emails.add('jane@example.com', type: 'work')
  #   card.phones.add('+1-555-1234', type: 'cell')
  #   card.addresses.add(
  #     street_address: '123 Main St',
  #     locality: 'New York',
  #     region: 'NY',
  #     postal_code: '10001',
  #     country: 'USA'
  #   )
  #
  # @example Generating VCard output
  #   vcard_string = card.to_s
  #
  # @example Parsing a VCard
  #   cards = Valerie::Card.parse("BEGIN:VCARD\r\n...")
  class Card
    extend Core::Parser

    # @return [Name, nil] The name of the contact
    # @return [String, nil] The formatted full name (FN field)
    # @return [Organization, nil] The organization details
    # @return [Gender, nil] The gender
    # @return [Birthday, nil] The birthday
    attr_reader :name, :formatted_name, :organization, :gender, :birthday

    # Set the formatted name (FN field) for this card
    #
    # @param value [String] The formatted full name
    # @return [String] The formatted name
    # @example
    #   card.formatted_name = 'Dr. Jane Smith Jr.'
    def formatted_name=(value)
      @formatted_name = value
    end

    # Set the name for this card
    #
    # Automatically sets the formatted_name if not already set.
    #
    # @param parts [Hash, String, Name] Name data
    # @option parts [String] :first_name Given name
    # @option parts [String] :last_name Family name
    # @option parts [String] :middle_name Middle name (optional)
    # @option parts [String] :prefix Prefix like "Dr." or "Ms." (optional)
    # @option parts [String] :suffix Suffix like "Jr." or "PhD" (optional)
    # @return [Name] The created Name object
    # @example With hash
    #   card.name = { first_name: 'John', last_name: 'Doe' }
    # @example With string (splits on space)
    #   card.name = 'John Doe'
    # @example With Name object
    #   card.name = Valerie::Name.new(first_name: 'John', last_name: 'Doe')
    def name=(parts)
      if parts.instance_of?(Name)
        @name = parts
      else
        @name = Name.new parts
      end

      if (@name.first_name || @name.last_name) && @formatted_name.nil?
        @formatted_name = "#{@name.first_name} #{@name.last_name}".strip
      end

      @name
    end

    # Set the organization for this card
    #
    # @param args [Hash, Array, String, Organization] Organization data
    # @option args [String] :name Organization name
    # @option args [String] :department Department name (optional)
    # @return [Organization] The created Organization object
    # @example With hash
    #   card.organization = { name: 'Acme Corp', department: 'Engineering' }
    # @example With array
    #   card.organization = ['Acme Corp', 'Engineering']
    # @example With string (department will be empty)
    #   card.organization = 'Acme Corp'
    def organization=(*args)
      if args.first.instance_of?(Organization)
        @organization = args.flatten.first
      else
        @organization = Organization.new(*args)
      end
    end

    # Set the gender for this card
    #
    # @param value [String, Symbol, Gender] Gender identifier
    #   Valid values: 'male', 'female', 'other', 'none', 'unknown', 'M', 'F', 'O', 'N', 'U'
    # @return [Gender] The created Gender object
    # @raise [ArgumentError] if the gender identifier is invalid
    # @example
    #   card.gender = 'male'
    #   card.gender = :female
    def gender=(value)
      @gender = value.is_a?(Gender) ? value : Gender.new(value)
    end

    # Set the birthday for this card
    #
    # @param value [Date, Time, String, Birthday] Birthday value
    #   If the value responds to strftime, it will be formatted as YYYY-MM-DD
    # @return [Birthday] The created Birthday object
    # @example With Date object
    #   card.birthday = Date.new(1990, 5, 15)
    # @example With string
    #   card.birthday = '1990-05-15'
    def birthday=(value)
      @birthday = value.is_a?(Birthday) ? value : Birthday.new(value)
    end

    # Get the email collection for this card
    #
    # @return [Collection::EmailCollection] The email collection
    # @example
    #   card.emails.add('user@example.com', type: 'work')
    def emails
      @emails ||= Collection::EmailCollection.new
    end

    # Get the address collection for this card
    #
    # @return [Collection::AddressCollection] The address collection
    # @example
    #   card.addresses.add(street_address: '123 Main St', locality: 'NYC', ...)
    def addresses
      @addresses ||= Collection::AddressCollection.new
    end

    # Get the phone collection for this card
    #
    # @return [Collection::PhoneCollection] The phone collection
    # @example
    #   card.phones.add('+1-555-1234', type: 'cell')
    def phones
      @phones ||= Collection::PhoneCollection.new
    end

    # Convert this card to a VCard 3.0 formatted string
    #
    # @return [String] VCard string with \r\n line endings
    # @example
    #   vcard_string = card.to_s
    #   File.write('contact.vcf', vcard_string)
    def to_s
      to_a.join("\r\n")
    end

    # Convert this card to an array of VCard lines
    #
    # @return [Array<String>] Array of VCard property lines
    # @api private
    def to_a
      parts = [
        'BEGIN:VCARD',
        "VERSION:#{Valerie.configuration.version}",
        "PRODID:-//#{Valerie.configuration.product}//#{Valerie.configuration.language}",
      ]

      parts << @name.to_s if @name
      parts << "FN:#{@formatted_name}" if @formatted_name
      parts << @organization.to_s if @organization
      parts << @birthday.to_s if @birthday
      parts << @gender.to_s if @gender

      emails.each do |email|
        parts << email.to_s
      end

      phones.each do |phone|
        parts << phone.to_s
      end

      addresses.each do |address|
        parts << address.to_s
      end

      parts << 'END:VCARD'
      parts
    end
  end
end
