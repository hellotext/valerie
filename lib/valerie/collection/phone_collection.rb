require_relative 'collection'
require_relative '../phone'

module Valerie
  module Collection
    class PhoneCollection < Base
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
