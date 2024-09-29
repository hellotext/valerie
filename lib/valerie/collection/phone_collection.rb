require_relative 'collection'
require_relative '../phone'

module Valerie
  module Collection
    class PhoneCollection < Base
      def add(phone, **options)
        if phone.is_a?(Phone)
          @items << phone.dup.tap { _1.position = options[:position] || @items.size + 1 }
        else
          @items << Phone.new(phone, **options, position: options[:position] || @items.size + 1)
        end
        
        @items.last
      end
    end
  end
end
