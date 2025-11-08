require 'valerie/address'
require 'valerie/birthday'
require 'valerie/email'
require 'valerie/gender'
require 'valerie/name'
require 'valerie/organization'
require 'valerie/phone'
require 'valerie/card'

require 'valerie/collection/email_collection'
require 'valerie/collection/address_collection'
require 'valerie/collection/phone_collection'

# Valerie is a VCard 3.0 parser and generator for Ruby.
# It provides a simple and flexible API for creating, parsing, and managing contact cards.
#
# @example Basic usage
#   card = Valerie::Card.new
#   card.name = { first_name: 'John', last_name: 'Doe' }
#   card.emails.add('john@example.com', type: 'work')
#   puts card.to_s
#
# @example Parsing a VCard
#   vcard_string = "BEGIN:VCARD\r\nVERSION:3.0\r\n..."
#   cards = Valerie::Card.parse(vcard_string)
#
# @see https://github.com/hellotext/valerie
module Valerie
  # Current version of the Valerie gem
  VERSION = '1.0.0'.freeze

  # Get the global configuration object
  #
  # @return [Configuration] The global configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Configure Valerie globally
  #
  # @yield [Configuration] The configuration object
  # @example
  #   Valerie.configure do |config|
  #     config.product = 'My App'
  #     config.version = '4.0'
  #   end
  def self.configure
    yield(configuration)
  end

  # Global configuration for VCard generation
  class Configuration
    # @return [String] Product identifier for PRODID field
    # @return [String] VCard version number
    # @return [String] Language code for the card
    attr_accessor :product, :version, :language

    # Get the product identifier (defaults to 'Valerie www.hellotext.com')
    # @return [String]
    def product
      @product ||= 'Valerie www.hellotext.com'
    end

    # Get the VCard version (defaults to '3.0')
    # @return [String]
    def version
      @version ||= '3.0'
    end

    # Get the language code (defaults to 'EN')
    # @return [String]
    def language
      @language ||= 'EN'
    end
  end
end
