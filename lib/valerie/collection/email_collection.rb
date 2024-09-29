require_relative 'collection'
require_relative '../email'

module Valerie
  module Collection
    class EmailCollection < Base
      def add(email, **options)
        @item = if email.is_a?(Email)
          email.dup.tap { _1.position = options[:position] || @items.size + 1 }
        elsif email.is_a?(Hash)
          Email.new(address: email[:address], **email, **options, position: options[:position] || @items.size + 1)
        else
          Email.new(address: email, **options, position: options[:position] || @items.size + 1)
        end
        
        @items << @item
        @items = @items.sort_by(&:position)
        
        @item
      end
    end
  end
end
