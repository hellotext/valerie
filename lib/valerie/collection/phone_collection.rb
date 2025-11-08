require_relative 'collection'
require_relative '../phone'

module Valerie
  module Collection
    # Collection of phone numbers for a VCard
    #
    # @example
    #   collection = Valerie::Collection::PhoneCollection.new
    #   collection.add('+1-555-1234', type: :work)
    #   collection.add('+1-555-9999', type: :cell, position: 1)
    class PhoneCollection < Base
      # Add a phone number to the collection
      #
      # Phone numbers are automatically sorted by position after adding.
      #
      # @param phone [String, Phone] Phone number string or Phone object
      # @param options [Hash] Options (only used if phone is a String)
      # @option options [String, Symbol, Array] :type Phone type (:work, :home, :cell, etc.)
      # @option options [Integer] :position Position in collection (1-based, auto-assigned if not specified)
      # @return [Phone] The added phone object
      # @example Add with type
      #   collection.add('+1-555-1234', type: :work)
      # @example Add with position
      #   collection.add('+1-555-1234', type: :cell, position: 1)
      def add(phone, **options)
        @item = if phone.is_a?(Phone)
          phone.dup.tap { _1.position = options[:position] || @items.size + 1 }
        else
          Phone.new(phone, **options, position: options[:position] || @items.size + 1)
        end

        @items << @item
        @items = @items.sort_by(&:position)

        @item
      end
    end
  end
end
