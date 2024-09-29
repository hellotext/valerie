require_relative 'collection'
require_relative '../address'

module Valerie
  module Collection
    class AddressCollection < Base
      def add(address, **options)
        @item = if address.is_a?(Address)
          address.dup { _1.position = options[:position] || @items.size + 1 }
        else
          Address.new(**address, **options)
        end
      
        @items << @item
        @items = @items.sort_by(&:position)
        
        @item
      end
    end
  end
end
