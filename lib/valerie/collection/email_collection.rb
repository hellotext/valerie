require_relative 'collection'
require_relative '../email'

module Valerie
  module Collection
    # Collection of email addresses for a VCard
    #
    # @example
    #   collection = Valerie::Collection::EmailCollection.new
    #   collection.add('work@example.com', type: :work)
    #   collection.add('personal@example.com', type: :home, position: 2)
    class EmailCollection < Base
      # Add an email address to the collection
      #
      # Email addresses are automatically sorted by position after adding.
      #
      # @param email [String, Email] Email address string or Email object
      # @param options [Hash] Options (only used if email is a String)
      # @option options [String, Symbol, Array] :type Email type (:work, :home, :internet, etc.)
      # @option options [Integer] :position Position in collection (1-based, auto-assigned if not specified)
      # @return [Email] The added email object
      # @example Add with type
      #   collection.add('user@example.com', type: :work)
      # @example Add Email object
      #   email = Valerie::Email.new(address: 'user@example.com', type: :work)
      #   collection.add(email)
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
