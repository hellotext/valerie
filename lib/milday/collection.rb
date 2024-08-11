module Milday
  class Collection
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
  end
end
