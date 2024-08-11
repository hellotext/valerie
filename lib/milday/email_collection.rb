require_relative 'email'
require_relative 'collection'

module Milday
  class EmailCollection < Collection
    def add(email, **options)
      if email.is_a?(Email)
        @items << email.dup.tap { _1.position = options[:position] || @items.size + 1 }
      elsif email.is_a?(Hash)
        @items << Email.new(address: email[:address], **email, **options, position: options[:position] || @items.size + 1)
      else
        @items << Email.new(address: email, **options, position: options[:position] || @items.size + 1)
      end
      
      @items.last
    end
  end
end
