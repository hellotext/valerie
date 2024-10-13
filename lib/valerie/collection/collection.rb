module Valerie
  module Collection
    class Base
      include Enumerable
      
      attr_reader :items
      
      def initialize
        @items = []
      end
      
      def each(&block)
        items.each(&block)
      end
      
      def add
        raise NotImplementedError
      end
      
      def blank?
        @items.empty?
      end
      
      def present?
        !blank?
      end
      
      delegate :empty?, :size, :length, to: :items
    end
  end
end
