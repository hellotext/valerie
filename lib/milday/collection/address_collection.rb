require_relative 'collection'
require_relative '../address'

module Milday
  module Collection
    class AddressCollection < Base
      def add(address, **options)
        if address.is_a?(Address)
          @items << address.dup { _1.position = options[:position] || @items.size + 1 }
        else
          @items << Address.new(**address, **options)
        end
      end
    end
  end
end
