require_relative 'collection'
require_relative '../address'

module Valerie
  module Collection
    # Collection of addresses for a VCard
    #
    # @example
    #   collection = Valerie::Collection::AddressCollection.new
    #   collection.add(
    #     street_address: '123 Main St',
    #     locality: 'New York',
    #     region: 'NY',
    #     postal_code: '10001',
    #     country: 'USA'
    #   )
    class AddressCollection < Base
      # Add an address to the collection
      #
      # Addresses are automatically sorted by position after adding.
      #
      # @param address [Hash, Address, nil] Address data hash or Address object
      # @param options [Hash] Additional options merged with address data
      # @option options [Integer] :position Position in collection (1-based, auto-assigned if not specified)
      # @return [Address] The added address object
      # @example Add with hash
      #   collection.add(
      #     post_office_box: '',
      #     extended_address: '',
      #     street_address: '123 Main St',
      #     locality: 'New York',
      #     region: 'NY',
      #     postal_code: '10001',
      #     country: 'USA'
      #   )
      def add(address = nil, **options)
        @item = if address.is_a?(Address)
          address.dup.tap { _1.position = options[:position] || @items.size + 1 }
        else
          merged_options = (address || {}).merge(options)
          merged_options[:position] ||= @items.size + 1

          Address.new(**merged_options)
        end

        @items << @item
        @items = @items.sort_by(&:position)

        @item
      end
    end
  end
end
