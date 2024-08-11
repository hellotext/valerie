require_relative 'address'
require_relative 'collection'

module Milday
  class AddressCollection < Collection
    def add(address, **options)
      if address.is_a?(Address)
        @items << address.dup { _1.position = options[:position] || @items.size + 1 }
      else
        @items << Address.new(**address, **options)
      end
    end
  end
end
