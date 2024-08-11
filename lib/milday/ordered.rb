module Milday
  module Ordered
    def invalid_position?
      position? && position.to_i < 1
    end
    
    def position
      @options[:position]
    end
    
    def position?
      position
    end
  end
end
