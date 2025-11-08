require_relative 'collection'
require_relative '../address'

module Valerie
  module Collection
    class AddressCollection < Base
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
